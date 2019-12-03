class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.20.5.tar.gz"
  sha256 "891a4336ba471ea92c784b08877380480a5d18600a5314262ca35258594acf39"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "7f720af59dbeac860ce89d9d03b84878770c0d4afd09c509df9c97f94625c186" => :catalina
    sha256 "87212af5c23c02f980e46d1ac67af08a6b5c983658e6b6808d126b0f488e9363" => :mojave
    sha256 "f067f5b4b201002c5c678e191b47f3ab38a084d584c43e2a7d924720ac0d4b3c" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl@1.1"
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
