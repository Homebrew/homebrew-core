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
    sha256 cellar: :any, arm64_big_sur: "38eb9ebf6ba630e5291a1c4c50943278858553bb70bc7302c163f35d289789bf"
    sha256 cellar: :any, big_sur:       "e97e845395083a8dd1261cbcae543f9707d3948180763e5dd96bd4f2b48f6f82"
    sha256 cellar: :any, catalina:      "03d0687354f87759cda216809cb7d3888936279a09002e47eaa6237d6245408a"
    sha256 cellar: :any, mojave:        "6347e3e5e40c312ba0ee7a0e1f6bc250f5386db981edcc354b8d102844344794"
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
