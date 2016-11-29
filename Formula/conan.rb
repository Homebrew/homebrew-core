class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.16.0.tar.gz"
  sha256 "118cf0a14a498107f5b17dad267aae0f277e48611017ae56282483371b21510a"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "8342e550b56ac1a0010ad42c8cfc672ee7ec639083b5471ae537f9c4bf1f8e47" => :sierra
    sha256 "5379ff1ecdbfccc5ba21bc72f385fe45500846df42389c065a8bdb62218513bd" => :el_capitan
    sha256 "53f5ca9358380ab6f321db1f24bd9a17d3b5fb285ba94fd368e92c5ae2688038" => :yosemite
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
