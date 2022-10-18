class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://newsboat.org/releases/2.29/newsboat-2.29.tar.xz"
  sha256 "18b9801e0c2948f29248bfd8f319a9f9f670993fdbd494c6464aaab9e325fd6b"
  license "MIT"
  head "https://github.com/newsboat/newsboat.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "cb6a7256342130ae146557201b3a2397f5a89a8a8aa3b9f3bac77cb4bb8f7a41"
    sha256 arm64_big_sur:  "3bfbf0e2b6f02eaf28aa995d7cd3e4d51cc3910f79b799fe79a02ad5faaf8ab4"
    sha256 monterey:       "64b1d266a80d1f3b4904241bc86daa98581130b5d3b2c48a34b846279e3f8251"
    sha256 big_sur:        "d2a26459b6caae18e304367517bfe9460b5b4b64b65cb6441c71412104c63711"
    sha256 catalina:       "442fad92d746195420c8077c79d90c845aad67f797d13d83d1118f7d11f90ac6"
    sha256 x86_64_linux:   "181e18b77ea6218024792a716f7cebd9fad53ba08acd083e8d68be27166a18b6"
  end

  depends_on "asciidoctor" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "xz" => :build
  depends_on "gettext"
  depends_on "json-c"

  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "ncurses"
  uses_from_macos "sqlite"

  on_macos do
    depends_on "make"
  end

  # Newsboat have their own libstfl fork. Upstream libsftl is gone:
  # https://github.com/Homebrew/homebrew-core/pull/89981
  # They do not want to be the new upstream, but use that fork as a temporary
  # workaround until they migrate to some rust crate
  # https://github.com/newsboat/newsboat/issues/1881
  resource("libstfl") do
    url "https://github.com/newsboat/stfl.git",
        revision: "c2c10b8a50fef613c0aacdc5d06a0fa610bf79e9"
  end

  def install
    resource("libstfl").stage do
      if OS.mac?
        ENV.append "LDLIBS", "-liconv"
        ENV.append "LIBS", "-lncurses -lruby -liconv"

        inreplace "stfl_internals.h", "ncursesw/ncurses.h", "ncurses.h"
        inreplace %w[stfl.pc.in ruby/Makefile.snippet], "ncursesw", "ncurses"

        inreplace "Makefile" do |s|
          s.gsub! "ncursesw", "ncurses"
          s.gsub! "-Wl,-soname,$(SONAME)", "-Wl"
          s.gsub! "libstfl.so.$(VERSION)", "libstfl.$(VERSION).dylib"
          s.gsub! "libstfl.so", "libstfl.dylib"
        end

        # Fix ncurses linkage for Perl bundle
        inreplace "perl5/Makefile.PL", "-lncursesw", "-L#{MacOS.sdk_path}/usr/lib -lncurses"
      else
        ENV.append "LIBS", "-lncursesw -lruby"
        inreplace "Makefile", "$(LDLIBS) $^", "$^ $(LDLIBS)"
      end

      # Fails race condition of test:
      #   ImportError: dynamic module does not define init function (init_stfl)
      #   make: *** [python/_stfl.so] Error 1
      ENV.deparallelize do
        system "make"
        system "make", "install", "prefix=#{libexec}"
      end

      cp (libexec/"lib/libstfl.so"), (libexec/"lib/libstfl.so.0") if OS.linux?
    end

    gettext = Formula["gettext"]

    ENV["GETTEXT_BIN_DIR"] = gettext.opt_bin.to_s
    ENV["GETTEXT_LIB_DIR"] = gettext.lib.to_s
    ENV["GETTEXT_INCLUDE_DIR"] = gettext.include.to_s
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    # Remove once libsftl is not used anymore
    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{libexec}/lib"

    if OS.mac?
      system Formula["make"].opt_bin/"gmake", "install", "prefix=#{prefix}"
    else
      system "make", "install", "prefix=#{prefix}"
    end
  end

  test do
    (testpath/"urls.txt").write "https://github.com/blog/subscribe"
    assert_match "Newsboat - Exported Feeds", shell_output("LC_ALL=C #{bin}/newsboat -e -u urls.txt")
  end
end
