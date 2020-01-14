class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.21.1.tar.gz"
  sha256 "4e920bf6b2e7db83152f6f6185ce70f14943f15ab2e50b0c29c022555822ebfa"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "7070709218f8a3fed13e3f0e066b27d08ca74c1ac6edf8e633a6aab3cc94040e" => :catalina
    sha256 "b4b4469ffe325552d5e0a52a90af9d9eb9eae85f77c18ce461bfc0cc8c60fc35" => :mojave
    sha256 "7e06a261fea8b60155c7f641070c7f102e4b77728899232a76646d826f051985" => :high_sierra
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
