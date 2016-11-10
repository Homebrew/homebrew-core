class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.15.0.tar.gz"
  sha256 "c463b394f722fca53d32f5abdaf7ae6ceadaa5328849c39ff0d4c6bd22b047c2"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "0d18c886c756b67b6a613291927a4c0e49f2b82d7119cd4647e834d64c70d4ae" => :sierra
    sha256 "ff0390091e41baedbfeafd3fb5e2c2a9d8f1f44c64f241c81629b83c4653f8cc" => :el_capitan
    sha256 "0e5aa82c1acfa458a934aabd6d09ad2579c64789a91d7267006e7844cc36b91d" => :yosemite
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
