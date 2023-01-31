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
    sha256 cellar: :any,                 arm64_ventura:  "bf4f49b3c17cc63802423a1a736329ec1a5f4054dbf97d237dbcff2a9de615db"
    sha256 cellar: :any,                 arm64_monterey: "a573534186804c46c9f8b4d68e8bfdabd591e4b23279f279c61c9d1776a373e7"
    sha256 cellar: :any,                 arm64_big_sur:  "88d5039d57727f98703ce034829ea5385b0c8235a0eda86ed3ca46be9bab21ee"
    sha256 cellar: :any,                 ventura:        "1f44429533a78b15cc508715c75901639b8ea26949e1e56e66e355e246de3323"
    sha256 cellar: :any,                 monterey:       "18e3bd079fa7f1f40a647f121a7d3ed8abb16260a2c6fb6927c928e34674905a"
    sha256 cellar: :any,                 big_sur:        "4697df4ec5db8204818230e23ce2bd27080f3d93a8a406a1eb0e3ff21a4053a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68ba62cd0a9dc7896da774197b65fcb439434f81d50ca1400d5c6ed9f54c9c9e"
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
