class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.24.tar.gz"
  sha256 "3a256f1026644f4ba79812fc7242e0342de5c4d12c6cbf2214c7d1af232e82df"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1e93deaf281928d90ba6a6a063207633bd2de4f4e0a29af2f444b2b92fb24cdd"
    sha256 cellar: :any,                 arm64_monterey: "b3e0f56a4a05f840bf8ef5af2b91fe7eca283d7e3af57bfc9b7cfeddc2319cad"
    sha256 cellar: :any,                 arm64_big_sur:  "ea1ad22e6a3057881287ec6e5b022f78fa4b731b117f65519aa5085060c8197b"
    sha256 cellar: :any,                 ventura:        "996d8bfc376066b39474a6cd02a349a1604e3938e176c33035b51acf32824710"
    sha256 cellar: :any,                 monterey:       "7edc730cb82e8160f924d0c7374bc99dc0f1e8b56926c7b94e7ca7f509d93c51"
    sha256 cellar: :any,                 big_sur:        "07298c234a62b2abc281455f4a37e1c6f4769ffc616409105c621d0a597efaaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1198cc9f259cdd039c33db40dc3a34f38dfe46689814c5e44cd4e7a5c50f5ed8"
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
