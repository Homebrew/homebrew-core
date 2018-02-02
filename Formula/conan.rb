class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.0.4.tar.gz"
  sha256 "46b428be2131f0daaec3038397cca5e0c760b7fff924621d31934dd6a27506d4"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "afd5368735804b506e40fa9bac985347b322e0163b61bb84edf4d6cd197817f6" => :high_sierra
    sha256 "73a3d3dbb16b0e97f05b9db40b711b1757f46850e22271e78e99653b9ff359c0" => :sierra
    sha256 "02d2c5681a7045cbe9a3fa23df47f255810bb0fa7b442f1bebfab35288c0a938" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "python" if MacOS.version <= :snow_leopard
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
