class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.19.3.tar.gz"
  sha256 "e015993e12f7e05533604423ba7c952e0de753cbf15ac5e4d4aaab863fc60cf1"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "b6b3a50469234832eee522b63c1609b0a342a53c04237232a0c5b65bf4434e3a" => :sierra
    sha256 "bc6d021c10e39a17d822d04958e37d9aed6c42dcf1a4ae1822a0c9ad53a6bcab" => :el_capitan
    sha256 "092c55cfdd76a067409e33f0c2c3f5636f58f210e5a96e88c0cd3bec1400b468" => :yosemite
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
