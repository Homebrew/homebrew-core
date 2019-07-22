class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.17.1.tar.gz"
  sha256 "3cfd55092f2580106774e81006b2bff24b531dd504973ca9f3f8b2883e5653ea"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "f1d2f4c1979beb4ef6f2211f58ee9023e2967ba6502f45c4375f9a4a47290d0d" => :mojave
    sha256 "4b29a412169b54c4cb74ae25982b4fa51077bd66b04bf72adfe7f4e9f290fb5e" => :high_sierra
    sha256 "075d7d095c15c4939d75e0fc2744ddc713edc0092402b0777b9d80bebb645ef7" => :sierra
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
