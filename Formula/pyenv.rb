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
    sha256 "9c3b77d720c63bb6c90e0363903f0ec045997472b4d9a94182d895221f844e0a" => :mojave
    sha256 "00c43a56bf9052e2b8a973360d6adadfa4a62abdc525ac6de0f7dd71f798d675" => :high_sierra
    sha256 "a2cad80ec482e98a9e9cd3cf59379b6454d479a97f918d78aed0b1781ed461ea" => :sierra
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
