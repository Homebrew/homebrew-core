class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.5.1.tar.gz"
  sha256 "9876637b10ec1959bd9fe031c380e07a1a94e22b4f6db4001edf6160f485ed52"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "c10e29162e937d5bae8006f36eda0738bb33eabeb253e48e8b1de7e229e1bf43" => :high_sierra
    sha256 "ee018a208b314df13eb265e40adfe89e86fd4d33acc8c933669a6021ab4a77b0" => :sierra
    sha256 "663e07d9921945c2b9f29441dd89bc88ee9ce19a9c58d01ac51bafadb8ee9953" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl"
  depends_on "python"

  def install
    inreplace "conans/requirements.txt", "PyYAML>=3.11, <3.13.0", "PyYAML>=3.11"
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", "PyYAML==4.2b1", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    system bin/"conan", "install", "zlib/1.2.11@conan/stable", "--build"
    assert_predicate testpath/".conan/data/zlib/1.2.11", :exist?
  end
end
