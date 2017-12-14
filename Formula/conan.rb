class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.30.2.tar.gz"
  sha256 "c6c8c00d028038825cf7bf9ee0cce88d8e273ed8feadf892e5c59acc4c1eaf90"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "41a918a66238c5ee3eccc379f5635d7dad72a5f7f4aeadd95887dec3ba6e40ea" => :high_sierra
    sha256 "418f47c4c39283d3ef36897197550118d49de1116573c96199e1d2106d5a2e54" => :sierra
    sha256 "c8476c787c62980bc19ad1a2a6b0c468a3af12550b85e54082b87d891fc468ae" => :el_capitan
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
    system bin/"conan", "install", "zlib/1.2.11@conan/stable", "--build"
    assert_predicate testpath/".conan/data/zlib/1.2.11", :exist?
  end
end
