class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.4.15.tar.gz"
  sha256 "87aad5b31293d4a4d9502a51084a41ac9652d013bd34e242615c2386fe2582f7"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f805937f522cc9162252981fdb981ffb6f642248ca120b27dee38d56c3c514e1"
    sha256 cellar: :any,                 arm64_sonoma:  "f37b21d93db633b3ac8b9407de0c439d19b4c776d5e1b89c4b3a8730f3c8d5a8"
    sha256 cellar: :any,                 arm64_ventura: "b581e0535332f5169062cfacf0a31759e637b1dbe90521e5bb6e900fd535017a"
    sha256 cellar: :any,                 sonoma:        "12417697f32532a255174f893c2b98704a3ed675bbaf333c33171fa02c363828"
    sha256 cellar: :any,                 ventura:       "d088025cb76b318c0f8466c6eb12356fdc6b3d2f5b031512542ba874429d5a30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc389696e8995cf27ca589754ce83908beb7ccea526b5a030a77c38b3fe0a361"
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
