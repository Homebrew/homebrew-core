class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.19.1.tar.gz"
  sha256 "2b3346ab024c81561fdc302e4bdb9c27d83696350253332a2c9cc22ed96698ae"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "aff5a5495786bfb3e5aa86c2d98cf7e3eb058dbe056a81a6003230f827b45506" => :sierra
    sha256 "269f0dfb3116c91b8dd18a547b7267e6d942a7bec50ae6af4a1bb66a55f46873" => :el_capitan
    sha256 "76bb746f2d548717991e6f86207ebfd29f68f8783aead46a5e77cc4dec8d599b" => :yosemite
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
