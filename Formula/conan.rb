class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.18.5.tar.gz"
  sha256 "5dd2c9709af11e8cb9b0aa7e77f01ca4173cca83ba5c3a207febb88eecbcedab"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "24f421bf0ba255f01e218ee1fd259ff30cfdb83954db7a77a24b1d590c59f103" => :mojave
    sha256 "8a19de6d01ecd2cefdba20de70082e95ba31dc74e39e5ae2babd12915ee1c08a" => :high_sierra
    sha256 "3d99264642ad3121d40037cb87222792da2ef344aeb6afe8272065f0693086fc" => :sierra
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
