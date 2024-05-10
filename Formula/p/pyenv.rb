class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "1ea2c12a0e66bc5dd0e8ae60ddbf252b305c92df7f5b3d1564ca9435bf65726a"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3d5af5cf0e7ade4210fd97750dbef6ecdd0be1e9b715c15dedb135601e36f297"
    sha256 cellar: :any,                 arm64_ventura:  "b97b62a8ed9e314599e2f473f381aa6f4ac185236ed2f14a0bd967c5df144eec"
    sha256 cellar: :any,                 arm64_monterey: "e18d179c41054d4ad28fc30b3bed3949f49493674fd1f7106f9b4c8e706c73d1"
    sha256 cellar: :any,                 sonoma:         "d9eef3b2c445334d8d56ddf4b875ddbd1884623076185df168b53db64ec46788"
    sha256 cellar: :any,                 ventura:        "62beb246b243cd83a4b21f712c0754fca8494638965972dc6b82a2479fc42ff5"
    sha256 cellar: :any,                 monterey:       "1f32d2b56d089ad7c7a889789a2ee46c19ab5e895176725b14c6d0996a723030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6f7c11229b395a41844d37573cb4639b0c4f059442626ad415321018b63ef92"
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
