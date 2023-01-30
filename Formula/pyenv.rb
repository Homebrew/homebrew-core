class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.12.tar.gz"
  sha256 "cb367f2c2f70dac83b56b5d770d2fca938dcb5a65c674be889a4824fd0c04319"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "9b79ec1167a26c7c6f8961b4102bdd37fd44fb7d1a526b36c099cb39d067b0fd"
    sha256 cellar: :any,                 arm64_monterey: "a0099cef864d52d0af0099a0abd3a2972b032a93a1923535b744550dcafac9a1"
    sha256 cellar: :any,                 arm64_big_sur:  "4a7a4aecaa279b1815070046dcc0f6604b0c935aeb8dbbe5a5c1655c5c467f02"
    sha256 cellar: :any,                 ventura:        "362d3060c9a309634047ec5537c31d1111ddeaae2b742c8f14224bde535096e3"
    sha256 cellar: :any,                 monterey:       "addc2ca142844c96693deebd0dadbb4778eb5063a5b8dcbe688e8fafbd22c6d7"
    sha256 cellar: :any,                 big_sur:        "f4e8f3369133cc2bf3a2c344fa90199fbb4d72db3920dec78aaea269b96b36d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b8952825eb1d5b3e34a50a7473232da9a7a9c8c89cb37d2cab4baa394857407"
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
