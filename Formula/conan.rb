class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.30.1.tar.gz"
  sha256 "d290d61947ab7f0d0f1ba2259f653a9406cbd42c461724af3d41829e5d5336be"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "e080ce82b83b50c8917b0737b2ad728449cd8a8c1656fedd45597405fe9a41f2" => :high_sierra
    sha256 "166bc4c1957d434b12f6f4b72efdf708360444504e700bddba78be3dfd589a8a" => :sierra
    sha256 "f4bd0766c923bf353e0803fab25f9534d2e3e1faa853b5226f342404dee539ce" => :el_capitan
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
    system bin/"conan", "install", "zlib/1.2.11@conan/stable", "--build"
    assert_predicate testpath/".conan/data/zlib/1.2.11", :exist?
  end
end
