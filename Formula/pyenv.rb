class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.8.tar.gz"
  sha256 "79c0ba0fa6fce3aa71e71d666d8082badbb52bc88dc3ed05b3c4b1ceeba54991"
  revision 1
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7b780d9fc25b882d27ea9c8fd1d26712bfef93151ce3da9482b17d3a606b653a" => :mojave
    sha256 "0c5f7419a9d26729335a95c8f547b88ece5165909b529aa2240191ea91388f97" => :high_sierra
    sha256 "433f3a6337dbb2e35d45aafba2589d58ee76c272e81e711691239529513d6077" => :sierra
  end

  depends_on "autoconf"
  depends_on "openssl"
  depends_on "pkg-config"
  depends_on "readline"

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
