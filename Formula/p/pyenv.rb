class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/2.3.30.tar.gz"
  sha256 "d6a7efe0d05c3f0745c292c8f4b5c6d50d45e3ddcf0e3cfd63947099a72ec202"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8e3bbbd282335a457e78c7619558a7a67187c2738d3b91ebf61db66550bb3c5d"
    sha256 cellar: :any,                 arm64_ventura:  "4f0e30797dbc0777d6f22d5ae0fbf419731d409c51025991a4f13ba0e5e0d6bf"
    sha256 cellar: :any,                 arm64_monterey: "7c54d7b3c50ac52fccf940c9aa71d14744f80f03fbdbef3f40ac2ca29b717b23"
    sha256 cellar: :any,                 sonoma:         "a55d3496ec6045c0ed6797178b827d39f6d49c34d77f21fb5b9e52cf3be5d9ae"
    sha256 cellar: :any,                 ventura:        "382ad6d651778fb89d6d9a763898b65b1d833c1152cbc8152723befd4907479c"
    sha256 cellar: :any,                 monterey:       "4f8d22e81e1d751d8e350f1b6dbe08d9db82767bb58871b916893cae2d44e3bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6cfb0b5822c07afd5e2644cf7a0fcd7d2dc4ee690091335d25221cd8f9b789e"
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
