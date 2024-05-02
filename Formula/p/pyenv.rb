class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "48d3abc38e2c091809c640cedf33437593873a6dcb8da2a3ffb1ccd0220d9292"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "423e0c467f4c0e07f093132d036790679752c6ec3e150966f448284e8666870d"
    sha256 cellar: :any,                 arm64_ventura:  "d36e0a02a291c69a97adefac255bb3ac051d4db2330991567e0f642335bd312f"
    sha256 cellar: :any,                 arm64_monterey: "c864a789872d8febd82456fbe97ee9f61f3f99b0d8624f46a418502fc8970526"
    sha256 cellar: :any,                 sonoma:         "717187999c534627f41052dcfa3d740bcc8cc0e3b10242ee8755d00e8b70d683"
    sha256 cellar: :any,                 ventura:        "3833eb68cf61a81be46cf8fdfb1f919817c6d433455f3feb0dd199470ad758b3"
    sha256 cellar: :any,                 monterey:       "825f2204bb2e642d6fc883db15ec0ef5873ceff81c6c37d3f8a89f00791d3c94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c2dc4ac138eb5d65d88ac65b84d0b572e66b2439e0ca4d16a8db943e418386a"
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
