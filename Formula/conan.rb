class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.29.1.tar.gz"
  sha256 "18a35f66df37c022f4589fcbe173431ff8d2f3b3e7f50a06b3c638096cd8e223"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "e65c82bd70f7338eb94056988b013c3f445ad99efe8a53b03198cb336be50d4c" => :high_sierra
    sha256 "1da6b9ffb2ffaae84ebd366572b3ec4f4e3836aa91404d2b56486c37302b7362" => :sierra
    sha256 "07a94d858be2a0941ce810b262ebba2b129f629c6e7f6b82bfb737144944b883" => :el_capitan
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
