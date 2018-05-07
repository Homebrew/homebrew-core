class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.3.2.tar.gz"
  sha256 "f75fd4470d306a99e3abcf435b186b2133b8306b675ea428dc8bf2fe43b598ef"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "f33092443958bbb27e64ec3b6e3ad50f988209c6bbdf6c4722877826aaa97c1b" => :high_sierra
    sha256 "124b6c49d2587f4590778f3fb5dee9271daa1dd5c141c40d47cf02414d4bee0d" => :sierra
    sha256 "1e2090f62c5bebea863fcd7f22c7a923ec1e29595ce84920033bc6e9ca2f6033" => :el_capitan
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
