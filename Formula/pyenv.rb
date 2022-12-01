class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.7.tar.gz"
  sha256 "b77d559a0b32286cd1ad636848d766c7bb7dd6495ca9bcf21357b31a1bc97c11"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c97447926b76da165b6f3f1c3212ba482b9a73f2dca5c6e7aee9401861c80286"
    sha256 cellar: :any,                 arm64_monterey: "87819c3d2531687c4d980e8bf8a5a8c7514b12a7165d8aea75f451f5bbccf5fd"
    sha256 cellar: :any,                 arm64_big_sur:  "735644e12860c65979da2938793b49ccf51bf6b353e35f5b54529a9075efc607"
    sha256 cellar: :any,                 ventura:        "1795b539df0ff82e1722c8dde6b32212ed6c3d47f163374e9b29a752f57ad9e7"
    sha256 cellar: :any,                 monterey:       "4a3f7ba1938986d5f47cf764abba85ef03a886a77cebcaf4ad4b6e492283ed8c"
    sha256 cellar: :any,                 big_sur:        "7ead9838b5d50b5d443a12d2865f455c7bbad12d14d5859c77d1e5fa26bc7095"
    sha256 cellar: :any,                 catalina:       "94c91ef556f0970a8cd1ff53321ee59e42b46fa6fb1b1b7b5ebbd5338ce1c51b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ba9657da7117f8d67aba782d06133b78fee09f4f3f8ca64f8e2c04a9c588653"
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
