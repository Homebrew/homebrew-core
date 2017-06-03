class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.23.0.tar.gz"
  sha256 "7960985bbbdb77dc7724aeeae00b482117d55f1a9609500b4ab153bc7f955ba9"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "b0174cb1e023e3742a214d28e8763317d64819eb8c2323c0f682d40c5095daca" => :sierra
    sha256 "eb1c339a78822ab961e903ccecaff1a11736ea0ad05b127a483d91fbbc7717bd" => :el_capitan
    sha256 "623b0beb3581f848f95df2f2ccb3760439bb5c895c08be41cc407116ef2f476d" => :yosemite
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
