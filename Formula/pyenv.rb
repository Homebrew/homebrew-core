class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.20.tar.gz"
  sha256 "69766b0b12b9be7e6e0057e1b3e55f0b48df2627598112b05f514f84c054ef0c"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "42be8775216093eedb44fcf1f7651da172cf5a2c86a9c07f1e140481ae0c381c"
    sha256 cellar: :any,                 arm64_monterey: "bfc9cde38ef1c97eb92d59eb37bf116c7b88cb7226dafb3bc2a57721e4203da7"
    sha256 cellar: :any,                 arm64_big_sur:  "4c095a941143b5b6f68062dd15e0f72a6b415068204e197bb9c84ac6d30fc52c"
    sha256 cellar: :any,                 ventura:        "cb8598f78cf4a05cbf089086be770ca817ba8e94aa5d2b21a6ddc2391c96beec"
    sha256 cellar: :any,                 monterey:       "f77ce8cd70604449cd3dde775274ae3b7c8ce3393b077e12341804f8d7646023"
    sha256 cellar: :any,                 big_sur:        "6a15d80906df9ac9aa01211964f640fc6e71fa8cd0eb4135fd5c8dc302647c58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8df442fd8ea43b9ec2bac22f08f55daf68106e38c1b7acc83975af169fa440a4"
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
