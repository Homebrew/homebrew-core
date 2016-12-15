class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.17.1.tar.gz"
  sha256 "d4801c65df8c55d2c6d28dd14c26bb12153e5bbdaad3dd8232b322aa8d81249e"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "e6bf7eb70bed79db2a7b0542921f88e33bb5b19fb55fac73775e63324d001d91" => :sierra
    sha256 "17c7286bfe0c7b1c330126ee93a5f0b2cecaba1fbd8450cb219798b8bb5f8864" => :el_capitan
    sha256 "f26133e5597b3e684ee6d5f64e6732687f2d45a46696b3775b61e6cea7f844ee" => :yosemite
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
