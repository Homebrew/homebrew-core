class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.5.5.tar.gz"
  sha256 "f1992bb226b4b258ff1ce3168c0470f87a1affa5f796d820f5dfc3d20bd82008"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a7e0676e9cba74afb89a5a889d04bc1c7ac53d483fda0c6425bbc509a14f70bd"
    sha256 cellar: :any,                 arm64_sonoma:  "b598fb34c36d9fb94907368058356bae7245d8520e4c9d71e49bd0c74ba50901"
    sha256 cellar: :any,                 arm64_ventura: "04dc2b1d21bc276c449aa35a1dbc1bf5c11886739ccadb81859a667eea3c65c5"
    sha256 cellar: :any,                 sonoma:        "376a9629e0f43c99a75c0b9d2fb9485a3c1db5351a763cba1426db578fefbcb4"
    sha256 cellar: :any,                 ventura:       "f3b5db4266807afa0607a543adacfdbb2fd59193d756e3ac95d56518509a8a68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe33cc0c55d76d8b3b2b0af72839bc58421d5faaa6b49eb3fe83a1022c248332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2ed6149d8940136492e34c4485bb687665607415d9c8b17b5f42f4721741511"
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
