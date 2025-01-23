class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://newsboat.org/releases/2.38/newsboat-2.38.tar.xz"
  sha256 "d6fef6f08948f107826e8dbbce35043c984e6e8517f90f5475da04e6e914db85"
  license "MIT"
  head "https://github.com/newsboat/newsboat.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "f17fe5c89d9d05d1e699d4f31c73867f6057529f3258af78513803d298897431"
    sha256 arm64_sonoma:  "0243d2cba34a5cb3ddeb47a48ab2f4a5572831fba6f6f375f23840216dfab513"
    sha256 arm64_ventura: "65ff1d67ce979e06ffe26f1cc1bec5678a72cc72c1d901ff4b1de89110bcc5af"
    sha256 sonoma:        "1943df946a712d69e2302f16bf0504fa0d8d6fd13b73b69e0720ab0fc1ecbdc0"
    sha256 ventura:       "e4134c046f1eca9d2966d29bfd40435648d74afc05015f5c2185145de8f2bf77"
    sha256 x86_64_linux:  "2e8c24e389a1de485b2fefd72eddcd76a5c8abe9e8197cc05705fb3737bda619"
  end

  depends_on "asciidoctor" => :build
  depends_on "pkgconf" => :build
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

      # Fix "call to undeclared function 'wget_wch'".
      ENV.append_to_cflags "-D_XOPEN_SOURCE_EXTENDED=1"

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

    # Work around Apple's ncurses5.4-config outputting -lncursesw
    if OS.mac? && MacOS.version >= :sonoma
      system "gmake", "config", "prefix=#{prefix}"
      inreplace "config.mk", "-lncursesw", "-lncurses"
    end

    # Call `make` as `gmake` to use Homebrew `make`.
    system "gmake", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"urls.txt").write "https://github.com/blog/subscribe"
    assert_match "Newsboat - Exported Feeds", shell_output("LC_ALL=C #{bin}/newsboat -e -u urls.txt")
  end
end
