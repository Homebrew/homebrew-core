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
    sha256 cellar: :any, arm64_big_sur: "433f3684d795186f16ff6669dc28c5130f0627eeb624f5cdfd9292220ebe7e22"
    sha256 cellar: :any, big_sur:       "c059ce48f3caa8a7f7a260e18e4491eb70e8250feaef787998d65ec457d6bd46"
    sha256 cellar: :any, catalina:      "ea35df8bdb58da7af95f22c965b94dbfd62cd2c59482b85c5189ada6e2dea28a"
    sha256 cellar: :any, mojave:        "1802e9dbbda4d6c2e73fd0c414c36bc04772ce59c6f52e3f68ba4284184efccf"
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
