class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.14.0.tar.gz"
  sha256 "1a6ca00e00e5446e0ca33869f14fca1a3caa8fae438dce7fe1aef8cc89c2e09b"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "0da87606bc183de8617d0d8bc3955b22965897e5a2bdc081e1110f2cdaab452c" => :sierra
    sha256 "f20b8fd59744d72d002b8aefa92029740ee5bdb3c54a455c9087fb5d694e043f" => :el_capitan
    sha256 "1a19cd21dd6c8779be52b0344397f467e7dd7a03f12c27407b3a60fae34b0c4e" => :yosemite
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
