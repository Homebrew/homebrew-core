class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.9.2.tar.gz"
  sha256 "ee87763d8c21207d57df3406f6ce761a407f82a50e5fc5a8b3fa9202bce61ada"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "5360c1d4e12e3517d9b21e9a6723f86c882a7a2bd8a42b66bce4c8fabda34bf3" => :mojave
    sha256 "2b310000c6b739e14ac28e867929275dad4db3be94ec78c39281cd37f91b185c" => :high_sierra
    sha256 "b085ac23ca6401b6bd54e28af037bcf12344cce068867d6c7cd1d7ddde26dcd3" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl"
  depends_on "python"

  def install
    inreplace "conans/requirements.txt", "PyYAML>=3.11, <3.14.0", "PyYAML>=3.11"
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", "PyYAML==3.13", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    system bin/"conan", "install", "zlib/1.2.11@conan/stable", "--build"
    assert_predicate testpath/".conan/data/zlib/1.2.11", :exist?
  end
end
