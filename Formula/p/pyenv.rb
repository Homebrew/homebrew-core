class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.6.4.tar.gz"
  sha256 "6e6e62d14ac924c4b55fe09991be02161bcdafaa1d45a36f99f3c2caac6d51bb"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "56ec7613f222b6f8120d16232b326c79ad2b5cdea6bc95e88e5b5c0b5fab0a3f"
    sha256 cellar: :any,                 arm64_sonoma:  "6f62be96b198d27ce9c814b6b2fbee000be4b811d7024cc676b1ab3ac3ec8f0a"
    sha256 cellar: :any,                 arm64_ventura: "5c96de13a4cc41fc4c3ee3b709cfdf68ba0440ebe3d1e9f5b7e0e859f79ae48a"
    sha256 cellar: :any,                 sonoma:        "8f13a4583cb733778be059249e042c391628990e21c1735d879adffdfab49428"
    sha256 cellar: :any,                 ventura:       "cdc34a609365c870c0611ed8081af845ac5582c5f21a48e92fd6d180414ceffd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59417c390b581eba036fa050c4e9769ab3b1db1bf64348e5e11a64a42aadffae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05e60892083980786bf12d2bbf5648bb24eb51dcff6be2b5540c1d68afc7392a"
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
