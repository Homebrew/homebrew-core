class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.0.2.tar.gz"
  sha256 "a1a6c1ff986bf132050e3ab393169fa7699e3cc1d939011fa7bbc8f59005b970"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "41e1bfdbfda283d68b78f12bdb95d9917dec43217e669f498017902c9fc521ca" => :high_sierra
    sha256 "19d03a9835cc7eccce61e7fb9f49cc050898cb8a0b54ed3a112939157492d60d" => :sierra
    sha256 "79d55aa1f30076ba47870d053224932e222f7e6f24ea6fb485006e567328274b" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "libffi"
  depends_on "openssl"

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    system bin/"conan", "install", "zlib/1.2.11@conan/stable", "--build"
    assert_predicate testpath/".conan/data/zlib/1.2.11", :exist?
  end
end
