class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.1.4.tar.gz"
  sha256 "ad2e6b74317434d9f76dda6e179c879ece2437808a4f4d134a842ca8d3f877de"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "f1496597ec5288a722fea46cf2c11b6aa4604d303f46e4a65f4eb5b348c38dcc" => :high_sierra
    sha256 "b1e8ca6bd6e97c69cf8d4708e64b94cde98b061b8e340e4d382086ded2c01a4a" => :sierra
    sha256 "a905854a7e63d9a3a239307b87a8e0b8a9b2c963b06f40ed957f4c7b12a485a6" => :el_capitan
    sha256 "2870c8d89369efd403014f005800f3aad02b84d261452c5e814ba3c9c64e7d91" => :yosemite
  end

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
