class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v2.2.0.tar.gz"
  sha256 "ef62a5d0a0d582b38497ae8d24a2a417d4a21c42811123c08082541a7092825d"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1d326dcae6327e1a62a8026e80665a0d995eec0d26c27f417ef34a9b75a2e2a7"
    sha256 cellar: :any,                 arm64_big_sur:  "38f17626731a50f95ce1ad71495de2d260706a1420a19f2f29e7c935525c8c01"
    sha256 cellar: :any,                 monterey:       "b02075ca6820755aee0956795c7decbfac56562ba66fec06bea193116cef5de6"
    sha256 cellar: :any,                 big_sur:        "880bf4a355cc3da07562b82bac1bf7d0f4bcde6c613f5ea691f50d4e013b1bf8"
    sha256 cellar: :any,                 catalina:       "5f7f283d3029f6293a52fc5449cf6aae8be5976f605318c9afa300be3e7d88f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb8949a118e2b8012383fe822148778944d24fe7eab36655fad6e1f1d506e2ad"
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
