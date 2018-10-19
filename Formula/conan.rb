class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.8.4.tar.gz"
  sha256 "ca10678dfe13e0b9a4b0c5df0f291263f99ee1ca1730a5087803590d35496613"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "46890f4898eb52946cd986febb715823368c6c1edb34c25672600fbf1b93fc19" => :mojave
    sha256 "4c2e554e9f88b7c260e9cc322502c017615ac46138dac76e00386a1a1e57ca6e" => :high_sierra
    sha256 "7fbd99360374e650f093ac1c2a727660dc593d849b0177f1e8dd128313b9750b" => :sierra
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
