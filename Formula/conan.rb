class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.17.2.tar.gz"
  sha256 "a5eefaa6fe6b0916102a96605d60090c41f26673c9c10b4cbcbf6818ae74f76c"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "d78f5834ab14b1f3ff6203d2515ed44032296c99e78fe77f85accdb3d5d33df1" => :mojave
    sha256 "a61058adefd9848fd05248da21ac91257cd5a2e67eda535dee26491a192a9685" => :high_sierra
    sha256 "b0ecf754bfb68652d43f99c0f1aca4189b3807df7488000df2eaa60aac4906c6" => :sierra
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
