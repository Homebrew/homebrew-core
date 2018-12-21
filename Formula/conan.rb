class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.11.1.tar.gz"
  sha256 "0611ef4a1a91066d07ff870b2acd518ab05cdd00c7a69874d236943135fac0b8"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "0c94e8dcfd1796d176f89b367e607b72359fa14e1076892957456070bfac1d80" => :mojave
    sha256 "06db4c91f014d33e4ca344fad09833f3a6594906951ac76a294c6fcb625c0628" => :high_sierra
    sha256 "f5061423a92bfbaa81c3d4adab60a38c4dea727996242bc363dd378b3fb164e3" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl"
  depends_on "python"

  def install
    inreplace "conans/requirements.txt", "PyYAML>=3.11, <3.14.0", "PyYAML>=3.11"
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
