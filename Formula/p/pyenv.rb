class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "52fd4d2e711a454e7eefb1302d4183119af76740c16c78eb3c30b7505519c80a"
  license "MIT"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3462d4a6f8decd281de5bec5f9f7dfa52597664e23497f385a715d4af233744e"
    sha256 cellar: :any, arm64_sequoia: "0d056236b9b682eea2ae1052a8b2cf860928d4510fe075188cb5bc22645f4c25"
    sha256 cellar: :any, arm64_sonoma:  "0ca6b8f71eb8ef49ac4eebdbcbe5933272845edb00109800add55d2e912a9ab4"
    sha256 cellar: :any, tahoe:         "368058491d0172d4d3468a8f4fd5c47787f498fd32dec7aab85e6d16b7025db0"
    sha256 cellar: :any, sequoia:       "db9f9bd89128563ca1f1e3a08d40633ea36809d2c3043c9c902f7dde2abcbbc1"
    sha256 cellar: :any, sonoma:        "7c0308da4c25b67774768e720ed2d81d3a3dbed5d4444034c653c2d368354aa0"
    sha256 cellar: :any, arm64_linux:   "77f7feb9db3ccb3909b0d535255fa206cd7e4b5952bc23155f98955c74fa74a8"
    sha256 cellar: :any, x86_64_linux:  "445fd438621f1366e335060a1c46a9e703a9db27961f99a094adf5393ba442cd"
  end

  depends_on "autoconf"
  depends_on "openssl@3"
  depends_on "pkgconf"
  depends_on "readline"

  uses_from_macos "python" => :test
  uses_from_macos "bzip2"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "xz"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    inreplace "libexec/pyenv", "/usr/local", HOMEBREW_PREFIX
    inreplace "libexec/pyenv-rehash", "$(command -v pyenv)", opt_bin/"pyenv"
    inreplace "pyenv.d/rehash/source.bash", "$(command -v pyenv)", opt_bin/"pyenv"

    system "src/configure"
    system "make", "-C", "src"

    prefix.install Dir["*"]
    %w[pyenv-install pyenv-uninstall python-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/python-build/bin/#{cmd}"
    end

    share.install prefix/"man"

    # Do not manually install shell completions. See:
    #   - https://github.com/pyenv/pyenv/issues/1056#issuecomment-356818337
    #   - https://github.com/Homebrew/homebrew-core/pull/22727
  end

  test do
    # Create a fake python version and executable.
    pyenv_root = Pathname(shell_output("#{bin}/pyenv root").strip)
    python_bin = pyenv_root/"versions/1.2.3/bin"
    foo_script = python_bin/"foo"
    foo_script.write "echo hello"
    chmod "+x", foo_script

    # Test versions.
    versions = shell_output("eval \"$(#{bin}/pyenv init --path)\" " \
                            "&& eval \"$(#{bin}/pyenv init -)\" " \
                            "&& #{bin}/pyenv versions").split("\n")
    assert_equal 2, versions.length
    assert_match(/\* system/, versions[0])
    assert_equal("  1.2.3", versions[1])

    # Test rehash.
    system bin/"pyenv", "rehash"
    refute_match "Cellar", (pyenv_root/"shims/foo").read
    assert_equal "hello", shell_output("eval \"$(#{bin}/pyenv init --path)\" " \
                                       "&& eval \"$(#{bin}/pyenv init -)\" " \
                                       "&& PYENV_VERSION='1.2.3' foo").chomp
  end
end
