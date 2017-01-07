class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.18.0.tar.gz"
  sha256 "9be3620b9913989221f5cdfa4ec852c00e50632183ba8b2b78d00ffa441f507f"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "1efae503cdaed62e2149a01429e0faf71f1c7432d53d041bc1d8083c2928a21f" => :sierra
    sha256 "2a520eeb381ba3b72ae15bd3c1c63916b4ff5d47365d67cd925a9d75a9df0aa7" => :el_capitan
    sha256 "ffe0714498b505413cfebc737ce0041b0842fa99287b71158c77de123d5aa187" => :yosemite
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
