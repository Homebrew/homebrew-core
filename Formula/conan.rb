class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.22.1.tar.gz"
  sha256 "cb3d85754aba214e656bfe018abafc6aa3c46fdab3e6140b691790ba86dbf407"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "e1bfd44b3563832b840535ebe9b0474a839aba65fb4fa0019213d44678815fe5" => :sierra
    sha256 "f5b79053133542cfdb351df9d53bdef02f62314c11e15cada8610741ea2b06d3" => :el_capitan
    sha256 "1779e45ed1ace3259c60b39d850f2d8ae1b98bb910bca4650b2cf276551e46fe" => :yosemite
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
