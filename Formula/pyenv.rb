class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.15.tar.gz"
  sha256 "cf6499e1c8f18fb3473c2afdf5f14826fd42a1c4b051219faea104e38036e4bb"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1a231740a15dc54da9b480eecf4f46732339e69aa75f599632cfe5e2c2bf0168"
    sha256 cellar: :any,                 arm64_monterey: "8d3e9eed7c4ee1cf151b0a8b91ada2f336b2359f51c6ae5fe40790f8d21eb0b5"
    sha256 cellar: :any,                 arm64_big_sur:  "b402ab24f893a012a8eacb2737b23705dd1701fb6786b801e26f769188ee1ba7"
    sha256 cellar: :any,                 ventura:        "80451e5241aa88a0ea7fc7456028245e03cd63c6ea20b044b2dc1b477f973ceb"
    sha256 cellar: :any,                 monterey:       "7fd01985fb3c3083be931e1fb54305e0d0b5a504ff0be68bddb1a2f376ca2fc9"
    sha256 cellar: :any,                 big_sur:        "c1db02100e601b82b4fcc03ceccaf2da2ea77feb9b120d27b307a0e27fe50d3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "291a825e68feaa753f4ade7f1fbd00f3a42126af88f44e967af75aea2deceb43"
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
