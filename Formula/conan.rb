class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.15.0.tar.gz"
  sha256 "bbb8b211b2ee6797a3933547917dc3da2cf091999f0b8dcb600fc3f041af2216"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "0d5845b530b86a82451464e690b54ce78b8a5c2993fe5f3f933279c1be507fd0" => :mojave
    sha256 "589ae18c132ab455e7812a655f53abc96b401716884069491a15811faba12d90" => :high_sierra
    sha256 "bf42107eeb69068861bd8d08eafc7d64c71edd79044a738fc07cc2631df2901d" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl"
  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", "PyYAML==3.13", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    system bin/"conan", "install", "zlib/1.2.11@conan/stable", "--build"
    assert_predicate testpath/".conan/data/zlib/1.2.11", :exist?
  end
end
