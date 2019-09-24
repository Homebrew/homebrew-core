class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.18.5.tar.gz"
  sha256 "5dd2c9709af11e8cb9b0aa7e77f01ca4173cca83ba5c3a207febb88eecbcedab"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "cb0036fa2866b800fccaf6e8513d6cc6ca6c64acfedc753463c3e7589c1ed6ac" => :mojave
    sha256 "afe7f2d8eb83109d3f3c00c4edd52d29434432b47991ae48b6ff6fc150cbd35a" => :high_sierra
    sha256 "71ee7572071d2bb0d4e40785f006629bb63521c60591a2f2d344a09dad2b8777" => :sierra
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
