class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.19.3.tar.gz"
  sha256 "e015993e12f7e05533604423ba7c952e0de753cbf15ac5e4d4aaab863fc60cf1"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "6cbd7a22103ac717318cd3faae04cd5cc263d1a88fc02d2e6ab3b1edacd14eba" => :sierra
    sha256 "e5f1cf7bea527ff3bb5b517a09c9423a99216e1f87ffd0d60a1deb1e76f78e29" => :el_capitan
    sha256 "c13283d84bd63e14928c20ee8ec550874f00c179a90656090f34e8d77485c524" => :yosemite
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
