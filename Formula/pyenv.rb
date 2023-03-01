class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.14.tar.gz"
  sha256 "54ffb70dd26169bcbc2abe761e4bb563e209f1ccd71b5f6737f82e82a7fc3d95"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "beea55c96989f84f1b804b63f1612b0b899a0d4f2011f9ecfae4e73d90f92fc1"
    sha256 cellar: :any,                 arm64_monterey: "f0f23b8562cee015f0e8c69f73228638bbe78b57ee03a0bf67fc055f2f5fdf99"
    sha256 cellar: :any,                 arm64_big_sur:  "2b34ade9cfb53fff88a38df4e5713afed38ef1bc0ac106dc2aa882594055a5a0"
    sha256 cellar: :any,                 ventura:        "35b2d29269ba890bea675e95ed110a76efd97ce85c5bf06ab1453216d2a38dce"
    sha256 cellar: :any,                 monterey:       "11c51f2f20084cbf5d022077712245a4cb89779e0a4f982a5f0002991512b4d2"
    sha256 cellar: :any,                 big_sur:        "be30d5ce494bec31c5ec01126b47867abfa9fda59753d438c0260a683af157d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78c314a1fe30a8df290b30ebe008f03c38099515f8c11feca506f273b2a3a2cf"
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
    #   - pyenv/pyenv#1056#issuecomment-356818337
    #   - Homebrew/homebrew-core#22727
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
