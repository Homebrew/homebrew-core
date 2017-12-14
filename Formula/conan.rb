class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.30.2.tar.gz"
  sha256 "c6c8c00d028038825cf7bf9ee0cce88d8e273ed8feadf892e5c59acc4c1eaf90"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "53e1387708477bceb887ba39eb06caf14d352d3bb81358302114d6cd1d0e038e" => :high_sierra
    sha256 "68522752cd57b97b51a20ec720e689de976a348c97954cc17071e0177a99e2cf" => :sierra
    sha256 "d8e8fbc54a937ef04e6d01ab06a81cf2db777d00fd990a1ccebb9f3773bb0507" => :el_capitan
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
