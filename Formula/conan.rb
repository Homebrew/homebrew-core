class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.21.1.tar.gz"
  sha256 "b92121720493c82b614d055cdb863b0746d78fb003f5b86da64121b09569b612"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "75b974787e805e32f0d0df23ba2fd93bd7023517813bb343b07057aa2e429def" => :sierra
    sha256 "7bea6dd5609187e01993cca33bb15315465220f9bec77ea0c7eb4889ec03136d" => :el_capitan
    sha256 "8e11fb9fdffb9791845aabf86f24375a94c21dc72090c635896cd3d36b475bfa" => :yosemite
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
