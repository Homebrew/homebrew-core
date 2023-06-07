class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.19.tar.gz"
  sha256 "30bbac703e30fefce856540aa375c225b01e9e47b0e320531b2910fc5dc99eea"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b5e4bb9a318f5fa71cecb07ba8eeab49c9a38f2ee3e5e553c1d8251dec278932"
    sha256 cellar: :any,                 arm64_monterey: "0b6ef759a44f8c10541ea0cb5733226ec991c0f2eaf1f75842ac6ec752b80bbe"
    sha256 cellar: :any,                 arm64_big_sur:  "9c066e947f034c22aed2572e0411c4e8a3806baaded13975f5ff9f9a010f4c72"
    sha256 cellar: :any,                 ventura:        "7f416ba98d9a2cb0911443a3713785400b238b2e26a9ec164cfa0aee59370bf2"
    sha256 cellar: :any,                 monterey:       "da0365435b44dd0dd52d57ba875901bb81e7a6c6b4289f8ab2fafdcfd9108bae"
    sha256 cellar: :any,                 big_sur:        "9e295fe796cf08f0de55a5d2d852ac3eaefd64694ae5221d791bb0f6c3d640f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85b90252c4ae9f2717ad32ba724935c7f0f6d53940ea0bea6ec2a5475b94a245"
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
