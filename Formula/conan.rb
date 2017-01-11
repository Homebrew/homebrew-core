class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.18.1.tar.gz"
  sha256 "cec4e3f6c4817d3cfea9ccfcecdf6aaa366d642b5de9c2ab59499a9f386b2075"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "358f60ab559c07ec28caff01c208172e3bd2131c30b27c627ddc57add5b31015" => :sierra
    sha256 "3d8200f7c7b4a50428b56a57d2e7d165704b27399aaa704bbfed56b7b715bd58" => :el_capitan
    sha256 "63c2ab8d9088b81005761e747c8b3e4c4ec62317a1e6364c8319b719705b7f9c" => :yosemite
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
