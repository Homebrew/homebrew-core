class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "7eb5a444cbcde94cbc4f67d056dff3a4db1502d4c491d7fcabb7870d8ecb595a"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4208c8e88263f2c972c96d91167ed11cd60b2a4ef700393034231e548ce6aa7f"
    sha256 cellar: :any,                 arm64_big_sur:  "7d344d9a98cc1d0fa0e41105b5215a4513325af1d8103495268098d0b53b1050"
    sha256 cellar: :any,                 monterey:       "842d020339f5a5b6eafd62b2dc8b4a5eccda640d6eb8c76e95e95c492a161196"
    sha256 cellar: :any,                 big_sur:        "d6a29992e1472574cb5bded1112d5cea106b15e17ca1f9518bda64d31a9bc5d4"
    sha256 cellar: :any,                 catalina:       "024e033702e5aabd989014042e90d05c1cf86bfa833c73db87bf7f19058236f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9d34c5949d82740310eb5e0c92723d7d00199b2cff4920c0401e5f04a7cc42e"
  end

  depends_on "autoconf"
  depends_on "openssl@1.1"
  depends_on "pkg-config"
  depends_on "readline"

  uses_from_macos "bzip2"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  on_linux do
    depends_on "python@3.10" => :test
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
    pyenv_root = Pathname(shell_output("pyenv root").strip)
    python_bin = pyenv_root/"versions/1.2.3/bin"
    foo_script = python_bin/"foo"
    foo_script.write "echo hello"
    chmod "+x", foo_script

    # Test versions.
    versions = shell_output("eval \"$(#{bin}/pyenv init --path)\" " \
                            "&& eval \"$(#{bin}/pyenv init -)\" " \
                            "&& pyenv versions").split("\n")
    assert_equal 2, versions.length
    assert_match(/\* system/, versions[0])
    assert_equal("  1.2.3", versions[1])

    # Test rehash.
    system "pyenv", "rehash"
    refute_match "Cellar", (pyenv_root/"shims/foo").read
    assert_equal "hello", shell_output("eval \"$(#{bin}/pyenv init --path)\" " \
                                       "&& eval \"$(#{bin}/pyenv init -)\" " \
                                       "&& PYENV_VERSION='1.2.3' foo").chomp
  end
end
