class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://newsboat.org/releases/2.31/newsboat-2.31.tar.xz"
  sha256 "4baf7de25cf569924eebb63a5ddc467cd58dd3f0e7190b327b49d0c1e454c1da"
  license "MIT"
  head "https://github.com/newsboat/newsboat.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "9086fd4e67f1996a09184cea5c9f599e46113664e38477f9e1da040debb26779"
    sha256 arm64_monterey: "0a68b75adb0ebff44a607edc8654e6d3946a28e06977e1801a9c5ba067b92c5b"
    sha256 arm64_big_sur:  "c21b1d949767a29e08356f4f8585984f42af77b27750af41a1afc958e3f65fd3"
    sha256 ventura:        "dd3a709f55bf8e02620d350621b0b243dd70eec142ba5d47b5c4e15b1333e7fa"
    sha256 monterey:       "80ea34fcdeecec18c9bbd02018109c7ef1e57601915421691ff46ac515945a83"
    sha256 big_sur:        "cc56fa48fd27139a6c8906721255a0695baf8c54bb5108f7a1ceaf5ff370c367"
    sha256 x86_64_linux:   "74e61cc78a02702eaf6f8342d22bc2e44e15b1cfd1c6ddd4bf7fb184d8ffa23c"
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
    depends_on "make" => :build
  end

  # Newsboat have their own libstfl fork. Upstream libsftl is gone:
  # https://github.com/Homebrew/homebrew-core/pull/89981
  # They do not want to be the new upstream, but use that fork as a temporary
  # workaround until they migrate to some rust crate
  # https://github.com/newsboat/newsboat/issues/232
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
