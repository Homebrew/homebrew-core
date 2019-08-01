class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.18.0.tar.gz"
  sha256 "726c7df28319f2fff39195b46253e9a9330fac0ce1440816ca9da97fd0644aff"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "0ae2545bb98f42e93b9394c45ee47c9b7ac790acb48f6ab6d4e6e2991bd76826" => :mojave
    sha256 "2d3b51a3ee2f10ef559ac36947ea6b75cfe679116b6b72fa87f4c44acff5ea1b" => :high_sierra
    sha256 "f1dd5fbecb5436ed955b1b69b5217e2271f3c1052699bc0e65fe439950e3359c" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl"
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
