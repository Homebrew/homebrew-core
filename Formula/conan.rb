class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.4.1.tar.gz"
  sha256 "2922500d598f9daceec2082eb334c3173a28d9be80bd903858a929aa3bb720ed"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "0e8093938aa01bcadbf538d77844f53c39e1e71b6d43f3eea522be7928ef5632" => :high_sierra
    sha256 "0b62f99c6af429c2af171be6a6cbcc7a9fa55d32dadd0958d5643168f4d21eca" => :sierra
    sha256 "28b5cac3a2b9dbc7e755cef0139ec58aea1e5d18b97a4db1e07261e34b169f06" => :el_capitan
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
