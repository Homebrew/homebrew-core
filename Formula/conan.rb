class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.20.3.tar.gz"
  sha256 "d725c43b5c9ca5a5c445ce258e99e9138630daccf6404c7282d5d13c7392a6cf"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "3649c002aec95f48d9e00fb8fb16b00129e07278757606e0b6f80818c34e0429" => :sierra
    sha256 "38ad526962b8f0141313c6e9defa902fdb55d6627311574c99174377c69768c2" => :el_capitan
    sha256 "7629cea74115f4e9a8e7718e3bc0b5c7efa3905fe12dfdd21ca7021a6ff4b6f0" => :yosemite
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
