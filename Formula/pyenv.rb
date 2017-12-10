class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.0.tar.gz"
  sha256 "80b5f5ecd92f5874bd5b4d775d2c57d0f2094287e27a61750360f39fcf32770d"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "d0be1995800fdee0487e6b14000151ff33c32c9c2281486d8ab5f644fcb68060" => :high_sierra
    sha256 "59c325b21bcef5868cd27c4cf62f97fdf3275e660d3d6f7a5ccd7c1401b79de9" => :sierra
    sha256 "ccb1dc328fc75ce442061d71a0e653f397646000d645d30ce5f09dd4da8da1cb" => :el_capitan
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
