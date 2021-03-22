class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/1.2.24.1.tar.gz"
  sha256 "846d6038ca350724532c6b5dc1cdf3549841d5672c2947dcb972463fb54855a7"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7063735a4ca450a9f76de4d88470654aba65e72aa459a67d840f501918e6b713"
    sha256 cellar: :any, big_sur:       "721c9ad24c32daaff25202899be4a2d5aa877578d4004197eaf137cf5f353dae"
    sha256 cellar: :any, catalina:      "cb44502dbac97e400122cb0244e7d7e0e07ffed5b19e3675fb947639915898c0"
    sha256 cellar: :any, mojave:        "5f92c1be17e003ecbe0159ff902591d0a2f4341c9d57284de35433bb6421f9d4"
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

  def install
    inreplace "libexec/pyenv", "/usr/local", HOMEBREW_PREFIX

    system "src/configure"
    system "make", "-C", "src"

    prefix.install Dir["*"]
    %w[pyenv-install pyenv-uninstall python-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/python-build/bin/#{cmd}"
    end

    # Do not manually install shell completions. See:
    #   - https://github.com/pyenv/pyenv/issues/1056#issuecomment-356818337
    #   - https://github.com/Homebrew/homebrew-core/pull/22727
  end
  
  def post_install
    system "pyenv", "rehash"
  end

  test do
    shell_output("eval \"$(#{bin}/pyenv init -)\" && pyenv versions")
  end
end
