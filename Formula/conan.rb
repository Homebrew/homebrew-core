class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.14.1.tar.gz"
  sha256 "98cf535e7cbc9da5de24615626acdb704b2798e7d5db6337ef7eb6a5a0e36f2b"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "2ee2a4ba03c69103fcbc9d6ed113e34ee83cb06af60b76c88a54ecaa0c90bc79" => :mojave
    sha256 "d2574944c5985014d1d75f32e0f8ab3449d306f106adbc34a98a95c87271fedf" => :high_sierra
    sha256 "f062b1f8565d9896729f4cb3cb8570f9b8b8c821d88efe2d607fe5aa4e19ec51" => :sierra
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
