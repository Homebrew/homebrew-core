class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.4.5_1.tar.gz"
  version "2.4.5"
  sha256 "a73d673f03baac56daa96cd47611eb2474a80599ffad3bf7a48e6748052ce498"
  license "MIT"
  revision 1
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8da234e11b1d9a6afd1173f111def5ec320bba2287fe1b84b12996a08d97103c"
    sha256 cellar: :any,                 arm64_ventura:  "b07e7770ee5536ddcb116000c2c05742e3faff8793fbd5939f1dd42bbf84a1fe"
    sha256 cellar: :any,                 arm64_monterey: "21f5464c17fd82d3cb459601b4f54d155b6c58139a23d8c7231f4b124ebc269d"
    sha256 cellar: :any,                 sonoma:         "916ecd8a0ed70d899ca39a7c0cf4bd6b4733bf13580adc67c4e4d538e8ce72d2"
    sha256 cellar: :any,                 ventura:        "e4c7075a48211cb4a0703ff84928073b0a57c989560fde190bd6b8f274682113"
    sha256 cellar: :any,                 monterey:       "447c9c68333a22f824d49a0e068e2ce2e752a47e649dc008fd67d2a3d426bfc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50fcd6804fa8520c55b3d339e4fb8f41a24e0657d2e488df0b5e689dfd515f0a"
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
