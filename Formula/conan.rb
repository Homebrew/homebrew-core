class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.20.1.tar.gz"
  sha256 "6f5f2a75c50fda7fe6d87bee5187400a7c41939e7c2f5fd3489c9d99790db779"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "b002952ed6521e3db709fb38a9fd4b898694da4ee8cd6301fc2c944febd90c50" => :catalina
    sha256 "de99534befddb5a93c9f73ed5c08595541e582b7e4ae27799d9b7985d1760ce9" => :mojave
    sha256 "b325f53e167dd02b0fcaf9df81d53f77fa5415d305c7932f513b0a4660706840" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl@1.1"
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
