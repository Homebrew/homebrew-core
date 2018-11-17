class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.9.1.tar.gz"
  sha256 "e244cc640805b459e2184712d56eeedcbe1ff4866275100ca252ec1c838129f9"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "482fcd8c717319e340ff9342c92fc83f2f8f332a5b5e413f1a2e55118bce9a1a" => :mojave
    sha256 "62694de4d0a2dd957fcded5b56e034f4f84432a12bce1e47d773da07ed4732cf" => :high_sierra
    sha256 "d2ba49662e4cfacd68750c150c52654e4022233fd4f7d1403b77a707e8923970" => :sierra
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
