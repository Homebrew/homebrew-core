class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.20.1.tar.gz"
  sha256 "507b5c58297abfaacea4979c2ca8c7cee0a0c62e839b1805b978caca68b51ded"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "46f777eb0cf938b95d4063fdfb537ad7c32e6a8f7b8756cb1e74bebdc727392f" => :sierra
    sha256 "2418f53930074253cd23d25dbe2b2c012f72c9b7be6f766635a8ff92f0c338e4" => :el_capitan
    sha256 "4e5735f74a882ffeba898bad2c6c6a40d9e4b6dced8f29245e13d87ca3993025" => :yosemite
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
