class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.36.tar.gz"
  sha256 "3b6f189f869fd7c712289c290a6e4dcc617382f1903560b88b4d82cf29305d99"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c4bf54d570612931776fe72ecf3266df21d4797ae331aaf754c8e9c42a580d8e"
    sha256 cellar: :any,                 arm64_ventura:  "2d34bde99fdab4ed2a69c32f3df7eece15834dc0f4d5cbf08d873fa947548719"
    sha256 cellar: :any,                 arm64_monterey: "ff8291320e2fbec388f35b94496554f21347bee7565f5a6daf686d27868c44b7"
    sha256 cellar: :any,                 sonoma:         "d117a99ed53502aff29109bfa366693ca623f2326e1e6b4db68fef7b7f63eeba"
    sha256 cellar: :any,                 ventura:        "d115c7e02e0b6dc287b938df1f4d924dd2f51404cd0338fe37cf3ecb4c8030c8"
    sha256 cellar: :any,                 monterey:       "793c27652b1bee70ae47ba9e17e60c5ac022af41049a517aacbc972cdd66daa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de5c91913de57e76a772ccabf959ac691fbb836b48b62caeaf07ee25094dd52e"
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
