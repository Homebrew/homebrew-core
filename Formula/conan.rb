class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.12.3.tar.gz"
  sha256 "89af5064f12f607c04ab5434aebe4e923df02a018e5c1d522b183ba05650453d"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "b74ddc5d080aec45372ba9b862d11f6d72951ebcbe9a392c29808dacdcd88da1" => :mojave
    sha256 "eb1216494b7b0d5b0f686c49e8eb9ba7d2269da9703f402501bfe79342849afe" => :high_sierra
    sha256 "113e439faa4bab5962d0be7f080d49e43de758595922eec683a217e1e72955e0" => :sierra
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
