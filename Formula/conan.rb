class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.12.0.tar.gz"
  sha256 "da1c3f646a422ebd6a1b365073d041041c643d8d5daaa1a6ad4055c2c9707943"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "7be34cbe112bd05a1877aaef4277743895da1658feef4b0aa923f5f236fdf59d" => :mojave
    sha256 "2cd46a76d9ee5c820739b299cb911cb1310e13ba239325cbf18569e7b8e205b9" => :high_sierra
    sha256 "990fbfc1cdd848a1d9b9983d7b663d76f6d127524c55a40dba389c3fa4d21063" => :sierra
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
