class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.22.2.tar.gz"
  sha256 "017e7cfa3a8e72910410d343fe26af01965a8c013ce6a749c7126805d7adb769"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "6dbad8868af8820f0e24fd02f8f680368c0a4ca038e37d13ba17b25451fddb57" => :sierra
    sha256 "45a5d3189da1de1a968376e2325c38cb9badb6a7a5db624f0bdf2fc6826d6be9" => :el_capitan
    sha256 "a45af86d872275f99bdccc88d1c4569a86850804a28f28d3661aceaccca3f181" => :yosemite
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
