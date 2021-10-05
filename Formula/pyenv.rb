class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v2.1.0.tar.gz"
  sha256 "464439c2f764b5ed9b00c97727cef0a7152be4ccbe703d54db43a48afe277a70"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "0a10714b40198d0bea81b7dd282bc3565b870cfbcf02309104c0408b570618c2"
    sha256 cellar: :any,                 big_sur:       "e8f8882207ec4d9d3a6d904ea81afef33e59c9c49dfeed34692e208b857564af"
    sha256 cellar: :any,                 catalina:      "b6a91e6b68d1951141bafd70d1612cdb369b18874a17cc058671cddb763706f2"
    sha256 cellar: :any,                 mojave:        "cde37127f8c2179ff34ff2a888e7b95ad299e1139297c958cbc4bfb2b4d9827f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffe64a4566542b8bdab0c8ad232004409db1fe58b2930dbc26d3de66923a3fbd"
  end

  depends_on "autoconf"
  depends_on "openssl@1.1"
  depends_on "pkg-config"
  depends_on "readline"

  uses_from_macos "bzip2"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  on_linux do
    depends_on "python@3.9" => :test
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
