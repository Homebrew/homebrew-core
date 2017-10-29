class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.28.0.tar.gz"
  sha256 "eadf4cb64ec89ae32944fe8092b07cc502e88a6b68a509d495557f37907fa739"
  revision 1
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "5f0400111a25a4f065e8e66fcc8dea6996f3dd722ea9291e844281800f5aec53" => :high_sierra
    sha256 "ec946a318294c4b857a6e68c2452a9d43e8ac2f550f3468c80b3b0dabe74c5c8" => :sierra
    sha256 "31ebaccbafe8936e7ddd85b57f5af62607eb9e210226e61b4b152704b631c4ca" => :el_capitan
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
