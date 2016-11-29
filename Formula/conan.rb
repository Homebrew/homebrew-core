class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.16.0.tar.gz"
  sha256 "118cf0a14a498107f5b17dad267aae0f277e48611017ae56282483371b21510a"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "ccecbbe76b364480bc300a0db617fe50c6b18cf3d977c10cb2a544ae23c8e080" => :sierra
    sha256 "ccaea1c1a7c6dd9ac4726e27ae3b442baf8cef82894aa47dec4e58ab38a7e5ab" => :el_capitan
    sha256 "c0a0ef05ef8e946a6e20c3e5bb2481893bc8d0fbc1ec590344c8e2f66f81d480" => :yosemite
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
