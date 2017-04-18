class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.21.2.tar.gz"
  sha256 "369d1c8d61ec9f8ea507acd0e104491979f60b27f74013362514d1796659347d"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "95a1f95ae270e5fe28706515fa03548ecac1485d77ba110e7b6ebccb5080a9ac" => :sierra
    sha256 "1d2874a106490af005d89c458d3cfe3a97ad0a092fb0bdbcdbc240ea503ab731" => :el_capitan
    sha256 "abd9dd1ed3d86ff42d398909ad6dcc2751e0d9e3496ab190f089d0a2fc4d2348" => :yosemite
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
