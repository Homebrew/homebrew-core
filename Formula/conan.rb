class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.1.1.tar.gz"
  sha256 "87f8535d260b3363e6ff2c8ad49c572851188eb8897b5af5ebc99d0733057498"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "866a63c6bf23d7ebafa9ea9f3a324f94cee85e91e069a2aa2b3d28b8b43e7909" => :high_sierra
    sha256 "7f0d5e6c4d5b8b074cab4751502a4975ebd5fceb9b46045baca99c56ee0f1ab9" => :sierra
    sha256 "09a33560030b15c872829f5089fb3a0587a165976fac576be849f7a1f6760e12" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "python@2" if MacOS.version <= :snow_leopard
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
    system bin/"conan", "install", "zlib/1.2.11@conan/stable", "--build"
    assert_predicate testpath/".conan/data/zlib/1.2.11", :exist?
  end
end
