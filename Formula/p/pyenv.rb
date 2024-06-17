class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.4.3.tar.gz"
  sha256 "bdd303f66977e7f6047c3dcbb00f7a3918c78f6b5a03f9d14a9205eea71f5e65"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ede740644145fd5fbf770e7661744b008510cfe239aa89c9f8c988f5e7db29d9"
    sha256 cellar: :any,                 arm64_ventura:  "c59cc765c45b348983bd5fb2bfa052ae5bd7f26e86034798d9e2e054977f30b0"
    sha256 cellar: :any,                 arm64_monterey: "3b8dcdb805fd4d2dd931b77d6f721e418a0954b9c46a98b2c55be8e5ec3367e4"
    sha256 cellar: :any,                 sonoma:         "5289de8cb86ee59f1bc697841c2b9b3e287485d6cf77bef8b1fcabe00abe6a1e"
    sha256 cellar: :any,                 ventura:        "eb98c4111d8a4f5256807a5731cba2992077044da76447eb068e3d7b218cbb1d"
    sha256 cellar: :any,                 monterey:       "cb466a49454c1b0eff9b3ac1b7a308a0a490fc8319b5e5463eb36bf15ca4df1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "962f4bd377558c2a515714d79a9d915bbb55c3c65fc92629d8962fd992cdd910"
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
