class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.15.tar.gz"
  sha256 "cf6499e1c8f18fb3473c2afdf5f14826fd42a1c4b051219faea104e38036e4bb"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ff68efd633ee282abb0c0a6ba72f90d5248644f3143f40e15841b6ae7996e3cd"
    sha256 cellar: :any,                 arm64_monterey: "af7621550cc7c005549d96218d2606a521e12595f2efc9ae9d8523cc46d318ba"
    sha256 cellar: :any,                 arm64_big_sur:  "69d69ceeea16fe45346d8856bf213c0a0e48220097635cf17d40b98fa8e12f83"
    sha256 cellar: :any,                 ventura:        "48fb21656dc11dc0a6ef25eb7cb5e8829485c1e1fac7d1ca596a46771a9ad91d"
    sha256 cellar: :any,                 monterey:       "96ba1d1702b7620dd9d0d2fe030af4d31c83504afea1b119910ab2e9c9fbb08c"
    sha256 cellar: :any,                 big_sur:        "f96dfcecefb40d4794a8ea3ef5981bdeab6e64c412f18f0c128b1d64fe87d913"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83737a776f4828a7fb5eb289b10418b7cf829cccca3fc634d7dfe7c96aff4e7e"
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
