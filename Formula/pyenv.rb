class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.0.10.tar.gz"
  sha256 "cc071d6a63445dc1f7cefa5961c74768bc3dadf8edab5c5a7e1d63bf536a99b5"
  revision 1
  bottle do
    cellar :any
    sha256 "bb53d2af447f7b4e54511a89f8a5b18e2d9d0fc44887241c0bea7532aca93e0b" => :sierra
    sha256 "c5ac14c00ed44d999ab972026b2a0fe3639b4144abb9668c5096de0f1f6e0cee" => :el_capitan
    sha256 "31db3cb79bb7f8213787faea877bb6bc688acd12e3905210b3d73f7deaf8bdaf" => :yosemite
  end

  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  depends_on "autoconf" => [:recommended, :run]
  depends_on "pkg-config" => [:recommended, :run]
  depends_on "openssl" => :recommended
  depends_on "readline" => [:recommended, :run]

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
