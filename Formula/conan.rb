class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.30.3.tar.gz"
  sha256 "1f0343928337d93ad4b47ff86bdea877ac6ee8bc35dcc714a10ecf061ec37e7c"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "2e66835a8aae776b2703afb05bef19d7f974178691853c3b0a956b5d86d259f3" => :high_sierra
    sha256 "d0ad13ba85ce1d96d3e387d2ca53ad2b4afbefdfbca5eeb12540e37eb4558174" => :sierra
    sha256 "416927d1d337455465e48aa691d04cac2d9b03fa8b0902b556d982a4b858cc12" => :el_capitan
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
