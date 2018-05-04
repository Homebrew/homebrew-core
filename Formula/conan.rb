class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.3.1.tar.gz"
  sha256 "5c74782d579f0a1f2d043332d304d949ba1688c5dfa581efaf54ebf88209e22d"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "bba3bcfa8a7657a1e37a2b8b7e89d6ce14d146cc630365380034e61a85386c0e" => :high_sierra
    sha256 "c568ab04c42dc051cc5b5c41b7200f64e45bdeef4f3caacc9b1746f968bae1e2" => :sierra
    sha256 "6d47bd19d88b0ead907d1bb06c39dcd5857422f14f7fd53d858f60c089974a6c" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl"
  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
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
