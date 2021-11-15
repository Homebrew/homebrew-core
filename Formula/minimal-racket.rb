class MinimalRacket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "https://racket-lang.org/"
  url "https://mirror.racket-lang.org/installers/8.3/racket-minimal-8.3-src.tgz"
  sha256 "dc67673f50f45cc5b7e2ee2602ba27c4a5ded3c037b5ac0cf1ca520bb9c37d62"
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
    sha256 arm64_monterey: "14c1869854645f1b8742a3ac0c96051101cba5499b91802971dca1243b8c45bd"
    sha256 arm64_big_sur:  "2a31213eb04748fdee09b5321e538d9c47ed8ef65c64dd629cffc981ff3d6fe5"
    sha256 big_sur:        "0beb52b95b6c4b5cce079f0f7e9067ba128baa0ebc271c81cb9b0b8758d34cf9"
    sha256 catalina:       "91dcb10fa642902388b949e3060e429413346ac0e9b7fe731d07969c93cbc6c5"
    sha256 x86_64_linux:   "a852cadfeaaa108399633e7167d9b51bd11261095c1f0830f920952b8a8bf91b"
  end

  depends_on "openssl@1.1"

  uses_from_macos "libffi"

  # these two files are amended when (un)installing packages
  skip_clean "lib/racket/launchers.rktd", "lib/racket/mans.rktd"

  # fix build error on Monterey, remove it at next release
  patch :p2 do
    url "https://github.com/racket/racket/commit/3a8a7102abff334ee4e054c3597bebba32bda307.patch?full_index=1"
    sha256 "16e0999348e991757b623748386d6ede3462a416cb95c1fa30421432a46f6ae9"
  end

  def install
    # configure racket's package tool (raco) to do the Right Thing
    # see: https://docs.racket-lang.org/raco/config-file.html
    inreplace "etc/config.rktd", /\)\)\n$/, ") (default-scope . \"installation\"))\n"

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

      ENV["LDFLAGS"] = "-rpath #{Formula["openssl@1.1"].opt_lib}"
      ENV["LDFLAGS"] = "-Wl,-rpath=#{Formula["openssl@1.1"].opt_lib}" if OS.linux?

      system "./configure", *args
      system "make"
      system "make", "install"
    end
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
        https://pkgs.racket-lang.org
        https://planet-compats.racket-lang.org
      default-scope:
        installation
    EOS

    # ensure Homebrew openssl is used
    on_macos do
      output = shell_output("DYLD_PRINT_LIBRARIES=1 #{bin}/racket -e '(require openssl)' 2>&1")
      assert_match(%r{.*openssl@1\.1/.*/libssl.*\.dylib}, output)
    end
    on_linux do
      output = shell_output("LD_DEBUG=libs #{bin}/racket -e '(require openssl)' 2>&1")
      assert_match "init: #{Formula["openssl@1.1"].opt_lib}/#{shared_library("libssl")}", output
    end
  end
end
