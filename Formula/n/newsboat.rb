class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  license "MIT"
  revision 1
  head "https://github.com/newsboat/newsboat.git", branch: "master"

  stable do
    url "https://newsboat.org/releases/2.40/newsboat-2.40.tar.xz"
    sha256 "1e656636009ffad3aeb87f8d0e4c36d2e913eac155b5f3ec85d00e8287b477c2"

    # Backport fix for Rust 1.89
    patch do
      url "https://github.com/newsboat/newsboat/commit/3a018bbf88fef74d1af24c79f5d640c6d753ab16.patch?full_index=1"
      sha256 "af1f0969b14ae80439e4e14c5126425221eabae285ba15eeb1c63980cd905612"
    end

    # Backport fix for curl 8.16
    patch do
      url "https://github.com/newsboat/newsboat/commit/c80d4c30901514188502f6f858b78a0896d9603e.patch?full_index=1"
      sha256 "92b86c657555c4b5c841e5a185c26f9b1532cd9423dc7fbbe12d3c433e2ccadb"
    end
  end

  bottle do
    sha256 arm64_tahoe:   "77be3fdd5e78e568ab0f85f4e579ad557b504450cbd957c0943a5c7a42cdb566"
    sha256 arm64_sequoia: "e21e148c22b1be21032db1cd876ff935df8131e9a732dd5b1092a8b2769268f7"
    sha256 arm64_sonoma:  "c0e8453d573451fd06bfb8115249fff274efe7b6836bff59b7484c645e0dafc8"
    sha256 sonoma:        "43b76b8fa54e2cc89ffeb1233755a9d2c344d8d58ac3a9fdaa1dda1f14e94aec"
    sha256 arm64_linux:   "859ab5f98262ab39657b2976f98302ce0b40f2849d8399e93cdf24014bb45818"
    sha256 x86_64_linux:  "2a66752a0919a45b762aa4b2198759f743370f60a3d7b66524037505fe49f037"
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

  on_tahoe do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version == 1700

    fails_with :clang do
      build 1700
      cause "https://github.com/llvm/llvm-project/issues/142118"
    end
  end

  # Newsboat have their own libstfl fork. Upstream libsftl is gone:
  # https://github.com/Homebrew/homebrew-core/pull/89981
  # They do not want to be the new upstream, but use that fork as a temporary
  # workaround until they migrate to some rust crate
  # https://github.com/newsboat/newsboat/issues/232
  resource("libstfl") do
    url "https://github.com/newsboat/stfl.git",
        revision: "bbb2404580e845df2556560112c8aefa27494d66"
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
    (testpath/"urls.txt").write "https://github.blog/subscribe/"
    assert_match "Newsboat - Exported Feeds", shell_output("LC_ALL=C #{bin}/newsboat -e -u urls.txt")
  end
end
