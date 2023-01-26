class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.11.tar.gz"
  sha256 "c133556734a301e4942202d4e2cffc5e1ddacf74a3744d0c092320903e582791"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "81880154a3a69227fad206f48dc95e0e8e9f8956a38f05fbb7b21ef568442730"
    sha256 cellar: :any,                 arm64_monterey: "a3b9342d0a392cb07130627f6077034d826d7dca09153e1f1b805832ae6636db"
    sha256 cellar: :any,                 arm64_big_sur:  "1a89511d30c74dfa1872d0fbc1a288c09b63ce5a127848fe49b36b6b62c93717"
    sha256 cellar: :any,                 ventura:        "986b5972498e79d273e201e21c4383427d3561cdd9a02bdc0e7767025e59ff6c"
    sha256 cellar: :any,                 monterey:       "be3e76594354d90736cc702719f0b6257999e3bc89e289837e44d1a465d6d5e6"
    sha256 cellar: :any,                 big_sur:        "a350b774e01f4510887725af14dde95e7f96900f61fc614b2a63b0d211450f2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93fb459dbd131c4545bc2da987a05c18add49623a84e011c7b0a7b405ec91d23"
  end

  depends_on "autoconf"
  depends_on "openssl@3"
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
