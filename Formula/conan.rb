class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.19.0.tar.gz"
  sha256 "1d3b3d3fbf66471170c150002e7887279609c20d4b4c7b74170a4c946c02dcb5"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "cc970db5305350d078c7ba5aedf6fef8d731404f9f40a34677115bcc778f4d54" => :mojave
    sha256 "da90272e8dcf49cdae3b26b9fea02a6bf54c6d78b081969efa60685566b04d1a" => :high_sierra
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
