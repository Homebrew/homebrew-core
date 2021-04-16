class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/1.2.26.tar.gz"
  sha256 "004a47be4919ca717bee546d3062543d166c24678a21a9a5aa75f3bd0653c5d2"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ecef415150807040a663a2303de95243c9da49f746cdc7208ab7314edb9d3d75"
    sha256 cellar: :any, big_sur:       "5c2c4b253c069c7461f9f657fdf8a526a6aedac5fed2263c65bb9aaf66efd805"
    sha256 cellar: :any, catalina:      "6a5736817f87bfbf97f355975a71ce99c72cff0afb8f5e29920c8eaac003f0ca"
    sha256 cellar: :any, mojave:        "8da46fc892af22ed501f9ff4fd96a06e9fa185653ada1a0887847e61787980e0"
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

  test do
    shell_output("eval \"$(#{bin}/pyenv init -)\" && pyenv versions")
  end
end
