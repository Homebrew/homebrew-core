class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.7.3.tar.gz"
  sha256 "fb3e009368dfd271e910795b38d338179a1a6cadf28ec6c0cd60c48c69c5e838"
  license "MIT"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c9aa7873e28a5041959c38461df26adf48e2024d955b6668ff415cd2c78e9f7f"
    sha256 cellar: :any, arm64_sequoia: "69ee09d4cbaa59de8ec72a80280cc1997da9976f8af093b4e99485dc1d7a3ac1"
    sha256 cellar: :any, arm64_sonoma:  "679581e4d4dab50c41a9a5c62a6945a11f72f10cdd2587823559b72eb268ed8f"
    sha256 cellar: :any, tahoe:         "7ba5b7242b175b8a2b6f4ba2be2472e9570be0f15a8e69d5eccf801409f2fbc2"
    sha256 cellar: :any, sequoia:       "c712b633b38a91fb9fa733b40b9890e1244b0e941c9b4268eef2ed411390c0d4"
    sha256 cellar: :any, sonoma:        "6ab9441aec1cdc2d62fffd4893366625b2a8f1b89a439b0b0102855ecdfd22b3"
    sha256 cellar: :any, arm64_linux:   "f531ee0ee59e0a853099e64f7dbdab77d91c820dbbb4e55ce79a33f8389adb39"
    sha256 cellar: :any, x86_64_linux:  "31d187b7a2777f9028617b439760c9c64bb0d66bf7c583eec19d750b1d71897b"
  end

  depends_on "autoconf"
  depends_on "openssl@3"
  depends_on "pkgconf"
  depends_on "readline"

  uses_from_macos "python" => :test
  uses_from_macos "bzip2"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "xz"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
