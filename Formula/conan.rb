class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.12.2.tar.gz"
  sha256 "096e55d9244a7e982d2a1a926945c03465c3b003b0eb22ade9487b81f0d8686e"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "ea3f98990f9489c4b0c2a1ea1812aa2c66ee9a7d65ca83a01522ed6a2c06c01b" => :mojave
    sha256 "3a50c64c316291134f87dff1222d25180f17821315a67cc6f350451641589b2d" => :high_sierra
    sha256 "64621bb9183df8ea2bd36c6d30c3ce63dd8a24c3f9524fe2c29e011ced9f8c6d" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl"
  depends_on "python"

  def install
    inreplace "conans/requirements.txt", "PyYAML>=3.11, <3.14.0", "PyYAML>=3.11"
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
