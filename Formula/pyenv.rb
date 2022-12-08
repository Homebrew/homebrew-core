class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.8.tar.gz"
  sha256 "f223595ce42d17c37ff08ee1bf349c7578203d5c5ea26540fb749aa86ae75f82"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3533bde543462673c31da0e668c899adc66683fbe734f5832229b43a9a6e0ece"
    sha256 cellar: :any,                 arm64_monterey: "e393e8f6adf38101d0330df05c7c744faa1e29fa2cb99d0399806cb66f020cf7"
    sha256 cellar: :any,                 arm64_big_sur:  "82b5d8d9ab7e39e9b256ce0bb03e0a6345d84a0c8bd8b21e8722f94423f81898"
    sha256 cellar: :any,                 ventura:        "255b02ac937710ef1a09cada5ce7ac805d94b6d8b694bc20a6ab72659aa6e6f4"
    sha256 cellar: :any,                 monterey:       "7ea7b62bda2eba687722ef4cc842eebae8e0853125e1e1651c6dc93a927f2716"
    sha256 cellar: :any,                 big_sur:        "1d919434390a8c3b3c2f9da8ae685e3f50c289ad38c290f3224820a6806a8171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c33586241182a300ad55a956326a7ca80fd1ddd8966da1f7edded0689d286a0"
  end

  depends_on "autoconf"
  depends_on "openssl@1.1"
  depends_on "pkg-config"
  depends_on "readline"

  uses_from_macos "python" => :test
  uses_from_macos "bzip2"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "xz"
  uses_from_macos "zlib"

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
    pyenv_root = Pathname(shell_output("pyenv root").strip)
    python_bin = pyenv_root/"versions/1.2.3/bin"
    foo_script = python_bin/"foo"
    foo_script.write "echo hello"
    chmod "+x", foo_script

    # Test versions.
    versions = shell_output("eval \"$(#{bin}/pyenv init --path)\" " \
                            "&& eval \"$(#{bin}/pyenv init -)\" " \
                            "&& pyenv versions").split("\n")
    assert_equal 2, versions.length
    assert_match(/\* system/, versions[0])
    assert_equal("  1.2.3", versions[1])

    # Test rehash.
    system "pyenv", "rehash"
    refute_match "Cellar", (pyenv_root/"shims/foo").read
    assert_equal "hello", shell_output("eval \"$(#{bin}/pyenv init --path)\" " \
                                       "&& eval \"$(#{bin}/pyenv init -)\" " \
                                       "&& PYENV_VERSION='1.2.3' foo").chomp
  end
end
