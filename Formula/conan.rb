class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.16.0.tar.gz"
  sha256 "cdb3ad099c5fbbc14d8a3732d1c5cd32530946043bd8d2122b7b300140c11f53"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "b80bff1c2e961cb570ad068166c70edaa27001d3f79ca0bdcfdb5e857273ada1" => :mojave
    sha256 "6f600898b8be5afed000ba6ba68416435a5eadde336ba30a5df287dd2d87325b" => :high_sierra
    sha256 "7766d9fd189e79df084721c73bc3a70fdc2d420368bc972f1984acc4916a7f6c" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl"
  depends_on "python"

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
