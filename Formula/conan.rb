class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.5.2.tar.gz"
  sha256 "4c69afca791aca98134daf446b39a03166ad9c0b6ae950650f84184c5dc3d4b0"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "163feca4aad365e4599fae0756b8348ce5aaaabce73c06b6d0ad48543914f505" => :high_sierra
    sha256 "7480a55d8817fd4bec5d76184d14ffe4f13aad080e6b92625ba6c3eb3aed52ed" => :sierra
    sha256 "4bbd4352d0ad9edd12e0794ad9a9a693f09a60431a8b6569141c7b602684f48e" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl"
  depends_on "python"

  def install
    inreplace "conans/requirements.txt", "PyYAML>=3.11, <3.13.0", "PyYAML>=3.11"
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
