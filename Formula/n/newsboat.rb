class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://newsboat.org/releases/2.37/newsboat-2.37.tar.xz"
  sha256 "4f54dea385c25b95e8ce0df1107f0336db41b18c645368e6164ce1070efba77c"
  license "MIT"
  head "https://github.com/newsboat/newsboat.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "300636df7d095784a08a1dc80c767a75f91c6b46428c341665f111763a2e325d"
    sha256 arm64_sonoma:  "a5c275ca088b11096188d1c16892ad95e31a3c7dde78d1a44c3b3ebde2e25e3f"
    sha256 arm64_ventura: "afa76014b9eb5526dd94e28258fdda1fc94ea795f3d0384054cd32ae911a2c07"
    sha256 sonoma:        "c7e9b83443b8d3e92b9a3d87eec6f7175d8f13644286508688f0c0e435ae64f9"
    sha256 ventura:       "c718942047b57a41b1c0610457603c85c8f74cd1027f4a22d3a21213e8a042ae"
    sha256 x86_64_linux:  "9b4badabe9019a7b23f157d6548b1d9a52291b5d9a77865082f18c486448d2c3"
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
