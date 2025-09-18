class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.6.7.tar.gz"
  sha256 "15b4a23711fea1ec8a320fb46ce39c176c80571ca33cd448d8863d9723c48d93"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1d4c804889c69fc850f5da787aa9d5a8ea43422ed5a7ba3d5f69494bce26a26d"
    sha256 cellar: :any,                 arm64_sequoia: "51efec46d0117014dad17575bef8aaa564f23602a116a14c37b4206657622598"
    sha256 cellar: :any,                 arm64_sonoma:  "01b5b3767f1f84a4c77759a5c4df38e15d53e12ed979888f2388f4218bc747ab"
    sha256 cellar: :any,                 arm64_ventura: "0056738be81cfc64bef6a9f2eeeaddeebb83b9497e76e46441a3eb3523beb905"
    sha256 cellar: :any,                 sonoma:        "c31873abf53438d63e9d30261911e7651e3a85b3cbdc8e8e4b009bfb5bc9f23a"
    sha256 cellar: :any,                 ventura:       "6f16dc642afc5b3d7aa086f6fae56b4093d082669fa9a95822059c8bc79a7268"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e873ab68f473317a96207e920a7faab48b6ccaa252b70541f49c744f2772826"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71bc7b4f484358a5b5c68c7f6aa5cbfe496c70d622fabab800ef63bf9c38a507"
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
