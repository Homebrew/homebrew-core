class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.25.0.tar.gz"
  sha256 "8048ee21b818b04fbba621d5e4c5418b9a5998548a98e4aadb41478702d52b18"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "d36f154d64a9656c1486648d1dd7c7a48bda8d18d45ec5c765d38392765aea42" => :sierra
    sha256 "ae481ed34cd3225e81840a464d54032dc9ca250d59e7538d06e24762dfc68a19" => :el_capitan
    sha256 "2933376adf23ac1e6e5e54473a83a56033dfc4389bc7e436f59e2615e4b484db" => :yosemite
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
