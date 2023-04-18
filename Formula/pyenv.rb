class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.17.tar.gz"
  sha256 "bffe53bcbb5e40515385a94410e2dbda3af644e6d94d2daddd5c5a136b6eb5df"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "252cbdec73fd36d36154565b163e7e483daa47f03caea969a35564cd037c4fba"
    sha256 cellar: :any,                 arm64_monterey: "fd02f2762eb920b724f9e7fb4d62d50cdccf13add045cb50c038aeefb0fe6f5b"
    sha256 cellar: :any,                 arm64_big_sur:  "24a000901c6fd2b98f67a0b6c92b2a0b61529298420eff04b8529520d4f5933b"
    sha256 cellar: :any,                 ventura:        "9139171688871f7d292fe18e17308463b1def90e0879d702f7173d2fb627e2cd"
    sha256 cellar: :any,                 monterey:       "86090438471b2fd52d9b953c934fd06dccac8ce87a90859b238ad2c99a590f7a"
    sha256 cellar: :any,                 big_sur:        "219425b6f81f8202c92af558d7af80cfb0ddcfb95c49dc5dc412d1005b6495cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0588e3066df3c716828255535a01103ad56c3c072dfe9b08a3646998e4685c47"
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
