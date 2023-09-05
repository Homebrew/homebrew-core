class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.25.tar.gz"
  sha256 "20a3f473695d376f68ec0c6a4d6c6157376f374b51848ce3be4b81bc27601ae6"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b61369257c38b16d6518469a202b028882a77b99ee9273211ba0327201a52f3d"
    sha256 cellar: :any,                 arm64_monterey: "89cf0e72c501699f5437a12d143edd2bb2cdbac7a5307592881dc546750715c0"
    sha256 cellar: :any,                 arm64_big_sur:  "33dd16900dc9b02ef16f9e7c54116c970ae5af123fb73c7cb32445cdfd4eea29"
    sha256 cellar: :any,                 ventura:        "bfc37ca73d6f89c6368e3195689c04db98f37af19709371cdbcf686c028577bf"
    sha256 cellar: :any,                 monterey:       "39f759224a2333c7571162a296f72acec2ae5bbe97b4e5ac96786e1db3f7e737"
    sha256 cellar: :any,                 big_sur:        "a9f7b15b9771ee4033e0f336125db14274738867f9747981391e7dc637f02dd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e2a4a9fa6c0e5b40ab6097cda85abb19359d93fd846165788b0323bc4c7ad7a"
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
