class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.24.0.tar.gz"
  sha256 "fe7fc766d3ff4997a700d141485ba7dd2768cf78eb710fed413a6ccea8b7f9a1"
  revision 1
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "c94656d8f672123aa1d562eb238bc4d6e7582b81968991dbde15bfcedfc0ff9c" => :catalina
    sha256 "4ca95babad6857f5c7d248e3d22920f1ea3736a8da9c60cfb134896d502da2f2" => :mojave
    sha256 "4d43c3c1a6d8e463314b9a2da3a4e1e0b51d2289be03179368a5c28ddb349bd0" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "python@3.8"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", "PyYAML==3.13", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    system bin/"conan", "install", "zlib/1.2.11@conan/stable", "--build"
    assert_predicate testpath/".conan/data/zlib/1.2.11", :exist?
  end
end
