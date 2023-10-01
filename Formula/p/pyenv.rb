class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.27.tar.gz"
  sha256 "600526bd8ee7e458e14376ba02e30ea9edf82a6f0bc5369836d0df5e7a32e81f"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "44ea044b20197daa91ee0ba3b4e6cc7d36614c1654ce292b33ff9173c05561e2"
    sha256 cellar: :any,                 arm64_ventura:  "9e55863d70a0d01961a983b773f198e2dbfcec47b6c7495442660e0ad9ff12af"
    sha256 cellar: :any,                 arm64_monterey: "d43c8f94f590540f7d1359a69925cad531ffa522f873514bf089d9cf9682c9be"
    sha256 cellar: :any,                 arm64_big_sur:  "7706202123316adfa410c40baebb892c2307eb1884b4f44e3756a2d5405c1f81"
    sha256 cellar: :any,                 sonoma:         "a0481f60b734d585775899883ba8ad24d68e12529374597dfecf6d7a371069d0"
    sha256 cellar: :any,                 ventura:        "e39b472b4d223abc17d251169d471315741d49eaa5ea5285e1d1c47713b18320"
    sha256 cellar: :any,                 monterey:       "8e7516a43be113a2f46b696fc4243a49ad7177b3cdb1acdd84fa0b4b478f438d"
    sha256 cellar: :any,                 big_sur:        "d40f881de5ff2026f42e3991ea37b637dc5e726f04d7562c7482cd3d238e49c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85ec38cd1bfca0d13c2bfc1fd483385aca386917d8d2ce192c3436b9b439dbb5"
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
