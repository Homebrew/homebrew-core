class MinimalRacket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "https://racket-lang.org/"
  url "https://mirror.racket-lang.org/installers/9.3/racket-minimal-9.3-src.tgz"
  sha256 "19bdc4f9507737e7f4a11b6411d184683c336b5942d0700ddaf2f4c54d639146"
  license any_of: ["MIT", "Apache-2.0"]
  revision 1

  # File links on the download page are created using JavaScript, so we parse
  # the filename from a string in an object. We match the version from the
  # "Unix Source + built packages" option, as the `racket-minimal` archive is
  # only found on the release page for a given version (e.g., `/releases/8.0/`).
  livecheck do
    url "https://download.racket-lang.org/"
    regex(/["'][^"']*?racket(?:-minimal)?[._-]v?(\d+(?:\.\d+)+)-src\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "b2348768dd8bf3c68b2d0809d00ba96c282db1bffd28e9f48ded2229cd17ce3d"
    sha256 arm64_tahoe:       "3479008f05780ee8b5512897c73df988f1744dc88ca782fe94c23fa1346b0e33"
    sha256 arm64_sequoia:     "ac8f242e9b8601b3c4b2a89314f2bb24c7d73b8d58071ab739c6e7f97d2548bc"
    sha256 arm64_linux:       "2e77bed0516c7e8eea6d00163eb203d4c8579d5b1ed1f1136e341674a370a5c9"
    sha256 x86_64_linux:      "cc96c4abe7aa7ac827300c53e6645456f8812c5f6cad78f5ec0285f9d07e5282"
  end

  depends_on "openssl@4"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # these two files are amended when (un)installing packages
  skip_clean "lib/racket/launchers.rktd", "lib/racket/mans.rktd"

  def racket_config
    etc/"racket/config.rktd"
  end

  def install
    # configure racket's package tool (raco) to do the Right Thing
    # see: https://docs.racket-lang.org/raco/config-file.html
    inreplace "etc/config.rktd", /\)\)\n$/, ") (default-scope . \"installation\"))\n"

    # Prioritise OpenSSL 3 over OpenSSL 1.1.
    inreplace %w[libssl.rkt libcrypto.rkt].map { |file| buildpath/"collects/openssl"/file },
              /"(?:1\.1|3)"/, '"4"'

    cd "src" do
      args = %W[
        --disable-debug
        --disable-dependency-tracking
        --enable-origtree=no
        --enable-macprefix
        --prefix=#{prefix}
        --mandir=#{man}
        --sysconfdir=#{etc}
        --enable-useprefix
      ]

      ENV["LDFLAGS"] = "-rpath #{formula_opt_lib("openssl@4")}"
      ENV["LDFLAGS"] = "-Wl,-rpath=#{formula_opt_lib("openssl@4")}" if OS.linux?

      system "./configure", *args
      system "make"
      system "make", "install"

      # Link to the Homebrew ssl libraries, overwriting the bundled libraries
      if OS.mac?
        openssl = Formula["openssl@4"]
        racket_libdir = lib/"racket"

        %w[libssl.4.dylib libcrypto.4.dylib].each do |dylib|
          path = racket_libdir/dylib
          path.unlink if path.exist?
        end

        ln_s openssl.opt_lib/"libssl.4.dylib",    racket_libdir/"libssl.4.dylib"
        ln_s openssl.opt_lib/"libcrypto.4.dylib", racket_libdir/"libcrypto.4.dylib"
      end
    end

    inreplace racket_config, prefix, opt_prefix
  end

  post_install_steps do
    run "raco", args: ["setup"], base: :bin
    inreplace "racket/config.rktd", %r{{{HOMEBREW_CELLAR}}/minimal-racket/[^/]}, "{{opt_prefix}}",
              base: :etc, audit_result: false
  end

  def caveats
    <<~EOS
      This is a minimal Racket distribution.
      If you want to build the DrRacket IDE, you may run:
        raco pkg install --auto drracket

      The full Racket distribution is available as a cask:
        brew install --cask racket
    EOS
  end

  test do
    output = shell_output("#{bin}/racket -e '(displayln \"Hello Homebrew\")'")
    assert_match "Hello Homebrew", output

    # show that the config file isn't malformed
    output = shell_output("'#{bin}/raco' pkg config")
    assert $CHILD_STATUS.success?
    assert_match Regexp.new(<<~EOS), output
      ^name:
        #{version}
      catalogs:
        https://download.racket-lang.org/releases/#{version}/catalog/
        https://download.rhombus-lang.org/releases/current/catalog/
        https://pkgs.racket-lang.org
        https://planet-compats.racket-lang.org
      default-scope:
        installation
    EOS

    # ensure Homebrew openssl is used
    if OS.mac?
      output = shell_output("DYLD_PRINT_LIBRARIES=1 #{bin}/racket -e '(require openssl)' 2>&1")
      assert_match(%r{.*openssl@4/.*/libssl.*\.dylib}, output)
    else
      output = shell_output("LD_DEBUG=libs #{bin}/racket -e '(require openssl)' 2>&1")
      assert_match "init: #{formula_opt_lib("openssl@4")/shared_library("libssl")}", output
    end
  end
end
