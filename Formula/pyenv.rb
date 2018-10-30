class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.8.tar.gz"
  sha256 "79c0ba0fa6fce3aa71e71d666d8082badbb52bc88dc3ed05b3c4b1ceeba54991"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "91995c220edec23af2798e302e3a197bee2c9a153dffb7f51e3a7308120b0a54" => :mojave
    sha256 "44c787de32fd6e1d17a79e6e927a20cfd175056948f0ad1bb621a6c2f06b8534" => :high_sierra
    sha256 "20c3dd22f4baa8b4557229483258d0c65bfefe8e4546c0a15a948e17ad51f315" => :sierra
    sha256 "86182bb87c253e24eb02a5c621e9a393c36dc9411678afb61dd934f6847237d5" => :el_capitan
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
  end

  test do
    shell_output("eval \"$(#{bin}/pyenv init -)\" && pyenv versions")
  end
end
