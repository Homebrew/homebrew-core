class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.16.1.tar.gz"
  sha256 "986eb6b9eeff2da1cb9704c7c97eb95bb2a83621d3da134d2eef80c74a0e32ea"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "c9a3ea694db8b38260b15854e944775d2a398591584f524ba7fd6ec5dda13833" => :mojave
    sha256 "7a9254477cc204e9f9de7e9c684d75f95ab1ad3ec26b057a2895e26c8115e7d6" => :high_sierra
    sha256 "babf2a2dad30f8b94e1fda450430114ee5940fddbdf5fe7f5421f7800392e851" => :sierra
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
