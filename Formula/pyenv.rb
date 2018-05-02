class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.4.tar.gz"
  sha256 "42e7eaa5422a0d5bcd8e7b5af95928cdccba3cb32763b2328c67ccd999ea46f5"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "549654b4707a262e71807389011cfa56a0d1e674e2e16bd7270366151d1ef206" => :high_sierra
    sha256 "86cb4dd57a8f9839f7830068ee2cb48d1715d6f23298362f3c0045641e34cdbf" => :sierra
    sha256 "c48a8f38cd4ddcd343b2a981a0ad6e991b980c5600ad1099953c758f21cb7af0" => :el_capitan
  end

  depends_on "autoconf" => :recommended
  depends_on "pkg-config" => :recommended
  depends_on "openssl" => :recommended
  depends_on "readline" => :recommended

  def install
    inreplace "libexec/pyenv", "/usr/local", HOMEBREW_PREFIX

    system "src/configure"
    system "make", "-C", "src"

    prefix.install Dir["*"]
    %w[pyenv-install pyenv-uninstall python-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/python-build/bin/#{cmd}"
    end
  end

  test do
    shell_output("eval \"$(#{bin}/pyenv init -)\" && pyenv versions")
  end
end
