class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.16.tar.gz"
  sha256 "699d6d87df08428bcd51ce2523a1dba18827a30bef4aea6fdd138935f2a875df"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4d9b4b4164c93adb1d8a0730ccf1ce961095b841eaed1cb5d42c70e4d967243b"
    sha256 cellar: :any,                 arm64_monterey: "42572c17ca89b2f500b4c850fdb129d9a67475d3d1af3fc517a5e25993ccfced"
    sha256 cellar: :any,                 arm64_big_sur:  "249da427c99ced3df04fbce5c6016eedc619a4de64465d7416280817948ecba5"
    sha256 cellar: :any,                 ventura:        "aa544e16917530a0ad636ead0324b9dd0057769f27bdb2962cb47c4ef9260e1c"
    sha256 cellar: :any,                 monterey:       "8b3512d631cf9a2010b14a82fa43138b5808cbab37cb7b47dbedbf7da57f85ac"
    sha256 cellar: :any,                 big_sur:        "357c538f94e6a77cf84dbe7e532f9d00f0d11a28e1b5497922aeccfb01d0d35c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aaf74c82ee53dc81c88dcfddf8254f7457fc40a90c769f440a797c8779ac039b"
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
    #   - pyenv/pyenv#1056#issuecomment-356818337
    #   - Homebrew/homebrew-core#22727
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
