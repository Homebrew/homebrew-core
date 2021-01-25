class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.22.tar.gz"
  sha256 "a1f5d8db3c80c1abda06b5a051f37e9a4898a43b3feb60ee82da7f23e4a3b75f"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "a322edd9999aee4027116f4ff65034c8bfd1bc1af8fbef136544330f62d003d6" => :big_sur
    sha256 "21cd3cc25153de842b519606d689824bddc55912b9021cbfedd80d25fa09d4d3" => :arm64_big_sur
    sha256 "b4f3038e29acde1d99579104ae100777621b9716fe797e7917dad1e9795d3473" => :catalina
    sha256 "525b4cc06fb46fd1e86d2272b4b692585679c5bb5c6a7b543cbdedd6f0096cf9" => :mojave
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
