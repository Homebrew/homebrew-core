class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.11.1.tar.gz"
  sha256 "0611ef4a1a91066d07ff870b2acd518ab05cdd00c7a69874d236943135fac0b8"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "54ca2d8daade8bd9cf3c85f41116dbe7c1d5de4e85c3f2e237ffa3e53670e9bb" => :mojave
    sha256 "4731753456896083c5e47b6ef0bd5470d1de05591ceb12e3383dd49435288531" => :high_sierra
    sha256 "80d64b919e69891083d1c66b52998222976fbd3c25a6108dadd5d445fc62e4df" => :sierra
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
