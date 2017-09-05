class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.26.1.tar.gz"
  sha256 "45d6e6c92df45c92e1312a746cb6bbfedf030d9d8039c0b6251b5f7d8d3e6a1f"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "a54af6d6dc2b298dfb0c1476537113ffb72d213ae05e5e1288e50a2ab2f7b317" => :sierra
    sha256 "bb1c619a6506bd20ba7f3790d2fae15b25ee9d48a498fd1249bf0ddb699b5633" => :el_capitan
    sha256 "7302bd7017a7e19ba6efdbde8fb5a4473f2c6364e12b028ccd9be1235ea2d771" => :yosemite
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
