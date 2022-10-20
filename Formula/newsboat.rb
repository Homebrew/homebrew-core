class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://newsboat.org/releases/2.29/newsboat-2.29.tar.xz"
  sha256 "18b9801e0c2948f29248bfd8f319a9f9f670993fdbd494c6464aaab9e325fd6b"
  license "MIT"
  head "https://github.com/newsboat/newsboat.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "bd4d256739e209041d93f13180476cbe93062fdb0fc6c737a25e2704b43c52cb"
    sha256 arm64_big_sur:  "df34eb234f50448d554bf21c69c8d14ade6ba64ac221210f8d4be68226f3e475"
    sha256 monterey:       "cf6d274222f6e12bd9f24c9f5c5a6e12c07be31405aa8316a715aca7587fc618"
    sha256 big_sur:        "dda7a1eedb4e426a16926f6bf0870e097eb1583386c6a28237bc874a13a9e9f2"
    sha256 catalina:       "516d5c9290a712e34dfe77afdc563cc97161f1e8f78ae454329476739e83ebcc"
    sha256 x86_64_linux:   "fba3e425c96473d52e1cd11690db80324994cf5fbf3b27d34127c798c1e6fdc6"
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
