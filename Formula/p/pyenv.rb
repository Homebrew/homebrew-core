class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.8.4.tar.gz"
  sha256 "6f80750a10d20f1b74252d81d543f0543c8f49ba9ea5804de8a82afedb4e3b8c"
  license "MIT"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "be9f8cdb92b3307ca8795cb2ad9614cf37685466fa2baf7d474d1ee474bf4f45"
    sha256 cellar: :any, arm64_sequoia: "a326b897e45f4695c3f5deef80f27e4aef8a8d625311edd1d77bcc62df953b20"
    sha256 cellar: :any, arm64_sonoma:  "d2f8a27215735930c10ee74302a5a7ada7655d03c4b0d2b3f30d19e2f523b569"
    sha256 cellar: :any, tahoe:         "3cc83c295e61f0e86f20e3245c8e62dcd6775b7268e9f6efc9f2582a10f2bfd4"
    sha256 cellar: :any, sequoia:       "6110642c6260540d2227df69fac557c3e71595ade35dd65bc87fddf023db8abd"
    sha256 cellar: :any, sonoma:        "ad06b9b01f8a49293e0a086320224b134bcda8aba5214bc31e3f47b8635a4800"
    sha256 cellar: :any, arm64_linux:   "5e0155891870afaa367a0718b07d812f7b94001ca6bb93804424e2bf22aec2e4"
    sha256 cellar: :any, x86_64_linux:  "9340a92f709c9969a7486ba58aa91539824a7e28ac23cbd7487128e0a193069d"
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
