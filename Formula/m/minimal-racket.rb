class MinimalRacket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "https://racket-lang.org/"
  url "https://mirror.racket-lang.org/installers/9.3/racket-minimal-9.3-src.tgz"
  sha256 "19bdc4f9507737e7f4a11b6411d184683c336b5942d0700ddaf2f4c54d639146"
  license any_of: ["MIT", "Apache-2.0"]

  # File links on the download page are created using JavaScript, so we parse
  # the filename from a string in an object. We match the version from the
  # "Unix Source + built packages" option, as the `racket-minimal` archive is
  # only found on the release page for a given version (e.g., `/releases/8.0/`).
  livecheck do
    url "https://download.racket-lang.org/"
    regex(/["'][^"']*?racket(?:-minimal)?[._-]v?(\d+(?:\.\d+)+)-src\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "4244cc788426d12ef29d9d0a68d5182df539d6a26723219176786c69da7a1e27"
    sha256 arm64_sequoia: "9646f072359dbec97b1cb86264642eda2cfbca28dc732380f58abb04561ca0e0"
    sha256 arm64_sonoma:  "a571f7a11dab2f9e844c2b277a94e16a69cb0984cc4fa9c952256c5f640a4606"
    sha256 sonoma:        "56912e55c16ea6c13257cc3de9cf9ba05e6e7b14fd06628a4247a8d1ed6818c9"
    sha256 arm64_linux:   "2ecae6e83ad95f50fdea665875c701be8aeeb8def5129b0cd6bcc80a31641afa"
    sha256 x86_64_linux:  "87c4409b73198f6915d370f09ac2b43fc984468c6bef28b0f59acfdd4b333627"
  end

  depends_on "openssl@3"

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
              '"1.1"', '"3"'

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

      ENV["LDFLAGS"] = "-rpath #{formula_opt_lib("openssl@3")}"
      ENV["LDFLAGS"] = "-Wl,-rpath=#{formula_opt_lib("openssl@3")}" if OS.linux?

      system "./configure", *args
      system "make"
      system "make", "install"

      # Link to the Homebrew ssl libraries, overwriting the bundled libraries
      if OS.mac?
        openssl = Formula["openssl@3"]
        racket_libdir = lib/"racket"

        %w[libssl.3.dylib libcrypto.3.dylib].each do |dylib|
          path = racket_libdir/dylib
          path.unlink if path.exist?
        end

        ln_s openssl.opt_lib/"libssl.3.dylib",    racket_libdir/"libssl.3.dylib"
        ln_s openssl.opt_lib/"libcrypto.3.dylib", racket_libdir/"libcrypto.3.dylib"
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
      assert_match(%r{.*openssl@3/.*/libssl.*\.dylib}, output)
    else
      output = shell_output("LD_DEBUG=libs #{bin}/racket -e '(require openssl)' 2>&1")
      assert_match "init: #{formula_opt_lib("openssl@3")/shared_library("libssl")}", output
    end
  end
end
