class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "7f81ae97116f1d00ae7558c3bba479ed19b114642ffd04c11612aa1b9ee74fb2"
  license "MIT"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "02540d5f5e3e1ccf0ad0c8805d5cae5a7c42b6ab11af3198fad83e0fd1713ee9"
    sha256 cellar: :any, arm64_sequoia: "85a2537b565d3a802007b0adff67fd02b8ef4a4c6bd651a36d27d7597220a5d0"
    sha256 cellar: :any, arm64_sonoma:  "d4c501fd9c3d178d4155891af26402bdf2ce7d6be4d16608a7804566c6049863"
    sha256 cellar: :any, tahoe:         "788725dc57426c3feb3bbd07c26444c230d51215423d5591defa5f5b99f80ba8"
    sha256 cellar: :any, sequoia:       "1ba7a54a16a0c585253fe580566e72edb430fda64017d6ee4cad1fa1604d17df"
    sha256 cellar: :any, sonoma:        "9e2581ea968c88c8240a0aa9ba384aabba29b8ca12c05275e6916a322b5611df"
    sha256 cellar: :any, arm64_linux:   "54310945326d0963a639d63b10d91520fd7523f17804ae61c07bf9c1f27f3d3c"
    sha256 cellar: :any, x86_64_linux:  "1d7ef7cbc3eb76a31d180c501b1bfbf5e4705f0fe773bc7c26f3279aa4281a1e"
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
