class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.9.tar.gz"
  sha256 "7ac658f98ed64bc9c5ef56614594dc052357853ec5703c8df91e9beff0d5177c"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b5e9d03663ec042ddb66b377ae863fa7a6db96c865acb6b95271769b7e69af8e"
    sha256 cellar: :any,                 arm64_monterey: "504165cf3839b597f1ce584c2de1e80cc013a2c0e0daadf91561bd7f6703ed09"
    sha256 cellar: :any,                 arm64_big_sur:  "53ed094151ed4ca94b2a23e99d2ac49764a6badbfb49341761905eeaff7cc46a"
    sha256 cellar: :any,                 ventura:        "05914a56201cba6fa98da7efd53d1e6a6e2fbcb4128323049b02704c4655b9cf"
    sha256 cellar: :any,                 monterey:       "7d204263a15e64294a2d4be2fc5d18d366ac1c2367b7bb5c8fc0431c31403967"
    sha256 cellar: :any,                 big_sur:        "39c01da586dec995d52bb447e40ad3bddb56c5411e3ed1577887c375be4820df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f03cc29d3c6c1040b376bea53730e33f218afc575067f23884d64a2bcc39b5a4"
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
