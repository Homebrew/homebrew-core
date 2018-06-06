class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.4.3.tar.gz"
  sha256 "b1b5be309c20ecf341355599437cc335d2b485af3bd6e381b05003e76d922aa6"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "f4cd9335ba77e2e4d7da94cf0aa9e87c35ee3c18b27128a21cbd7cef59083df3" => :high_sierra
    sha256 "a2a106995b28c256438612a804bd8ee131be78927bea17237932362508204051" => :sierra
    sha256 "ac8aa602254f3970bf9b82441bb705625f5d00e88541100e8a03116632c1c6d7" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl"
  depends_on "python"

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
