class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.17.2.tar.gz"
  sha256 "f5ba2d93936f725608b1628358d5c424e2f9386e7ca355ea1b1994112734bead"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "611190ece49b7184b8d475d737b00297b6b9c780f7883671ad02ced865d1d82e" => :sierra
    sha256 "38cd6832ce5023b73d8ec2d145486e6d28b93a3d857c719ea8dca2bb57682549" => :el_capitan
    sha256 "9f7c4c962de6ed07565c56f524f045951bff6fea086eb06688dd5c109b2c0d51" => :yosemite
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
