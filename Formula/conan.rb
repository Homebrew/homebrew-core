class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.10.2.tar.gz"
  sha256 "c7e9bd3076eae48b8416274233a7343f12ba440fe2a35b78d0065c9707ecd6c6"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "c2b56e37b2c7fb07a48b736a833566992ac2766304528aa4eb398f40b3541cd5" => :mojave
    sha256 "10b3cebb883c45b902185d38ee41da9fa9b1eb7ffb7eddad340df57e65987d1b" => :high_sierra
    sha256 "c5ac99b7daaef6b14d2570dd3c12d0019f5df00412055190383503e606948cb5" => :sierra
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
