class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.8.4.tar.gz"
  sha256 "ca10678dfe13e0b9a4b0c5df0f291263f99ee1ca1730a5087803590d35496613"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "0a01b2c09bd3d1526e0a6c719a34fbee9db876d15d5b8d53c579e4927fad0bfc" => :mojave
    sha256 "40e99319d849fe23400731262de657d321795c3c32b77c9f25daf20f86c0aff0" => :high_sierra
    sha256 "0ef739318eb9d9a0d70303b4edf62b451614f6bf0122da053de12a7c49706cda" => :sierra
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
