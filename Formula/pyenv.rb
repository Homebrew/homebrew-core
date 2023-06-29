class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/refs/tags/v2.3.21.tar.gz"
  sha256 "f922339c4d64e7bc8526594f5b42355963edfa94b08f01bc398360e371b7d6fc"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fcc500f3ca50f3c92f3e472055b946b1aab23a109c587ef6d2e8a2a45abf2c2a"
    sha256 cellar: :any,                 arm64_monterey: "2656dee1333127948fcd4c425e08bd234264a862f061ad87d42712bf5c854aa0"
    sha256 cellar: :any,                 arm64_big_sur:  "cf6351df3ad46b845e9d84572a1d9e2527f6a022c52848d3369c73141e0fa17c"
    sha256 cellar: :any,                 ventura:        "9f45209f33e300238f5cbbd7c4ce0d1aca6b2959de488e6ad8a8a44f67e48779"
    sha256 cellar: :any,                 monterey:       "e0c3283e6322d6ac05796cc5ee8b90fe4a8d3d6e51d16eee034a47e9c578b5ce"
    sha256 cellar: :any,                 big_sur:        "8f4d5c8d9de204c46953b3fb20c2d9b5c45b14251da91b21e698363dd303a62f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93494529cdd695fb1816aef198a90daf4929f44b0e088c83202efd0f3c817c58"
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
