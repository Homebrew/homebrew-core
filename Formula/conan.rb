class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.21.0.tar.gz"
  sha256 "85e3379604a89b09365865a17f7c746f3a3953ef99c1bdf4faa5c60f89b097b5"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "2cf58ccd0e851c84e01a64f16a6cd12a14dd849974a48904a2a459670cdefc76" => :sierra
    sha256 "4df95e3daf24c59b99d38b839c3ea0c902643b38d6f59b61d8e8b3a758a2f88f" => :el_capitan
    sha256 "2f67010b1434e17fe6777a7381fdb7995fddd5ebe496a3cc28ffccda528bada6" => :yosemite
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
