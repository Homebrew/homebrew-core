class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.14.0.tar.gz"
  sha256 "1a6ca00e00e5446e0ca33869f14fca1a3caa8fae438dce7fe1aef8cc89c2e09b"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "8594084c880394046a7c3b9dcd08feb7c984ffd0193ca9893e0c846733ebea35" => :sierra
    sha256 "5c336dc11e27b1dadeb8dda031a74f63c1616c5aecce1a57c6127f5af0d4ec27" => :el_capitan
    sha256 "a9186285c99d3c4aa344d01eb8374f72529c2c8716ef90d931f031df1b8625d0" => :yosemite
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
