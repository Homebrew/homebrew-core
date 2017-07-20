class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.25.1.tar.gz"
  sha256 "99713b7bd7d0e33f4dc7716aa89849dc580ddfce9e89ac22063b88eea514d302"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "95143435438b2d6cbfcd72baf76aba602f4b88d97b8621c08f7e6ef8baa2eff0" => :sierra
    sha256 "932c89d141613114e708b8cb428e9278266f9a9fd254f2c74cfb79c79be0fec9" => :el_capitan
    sha256 "b9de11726517454b4496f67b058f798aec8b30790379da24028836f1d1badc06" => :yosemite
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
