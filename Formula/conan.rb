class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.25.2.tar.gz"
  sha256 "7d4f08688c00635778abf36713f7dfa554e3b5c797e12c1268c16248f702c970"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "a3c8bc8068aa95d5b4c12dd4db1f9f7758bdefdcdbad64671d392141fc53dcaa" => :catalina
    sha256 "fab6aed495b8e52e3ccdb24546657908007539b08536c7024bc4a07d1e5a4d93" => :mojave
    sha256 "767e5d8a0404dc0a6325948f4411f58e1166d905edf6c98779de380304466fb8" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "python@3.8"

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
