class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.23.2.tar.gz"
  sha256 "702cda9ef1163457150db9156ba27dc335e611f9afc0819bb3054b44565957ec"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "58070c63704eac276b28d173370542e6a0df288866e4ccf12c3e6eb991de5370" => :sierra
    sha256 "20cb1171a20e24b14749d42d2fc07da7668ebcc7ecb46d4dce3fea392a9121e2" => :el_capitan
    sha256 "5cfe9f0e0d1edbb4049094de1350937a14cff00e186c80369361ab0d1085cd7e" => :yosemite
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
