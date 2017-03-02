class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.20.1.tar.gz"
  sha256 "507b5c58297abfaacea4979c2ca8c7cee0a0c62e839b1805b978caca68b51ded"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "bc677b80a739db1549672e1ab193be16509075e4966d492137d229b11c70b43a" => :sierra
    sha256 "b66524de014f0d856f9bc9dfe4f01a3a79eba2a09e234b07d313c14fff16f9d7" => :el_capitan
    sha256 "1de38bd4df56b7d0c281b88e75986c60661d211dbe27f53526f839c6e2fd7eb9" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on :python if MacOS.version <= :snow_leopard
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
    system bin/"conan", "install", "zlib/1.2.8@lasote/stable", "--build"
    assert_predicate testpath/".conan/data/zlib/1.2.8", :exist?
  end
end
