class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.2.3.tar.gz"
  sha256 "12ea5aa2f6faf2484613129dec4c1ce4d0b3459d488160a4b00cb7f091650b05"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "d69c530a1317d92ae981e46f563bb5fabebfeb839fd48d5a82ce75ef5d1d3725" => :high_sierra
    sha256 "5c28444d31bb384c337531b4f15fa7e56eab718189d4f91edfe2cbf0d9f961be" => :sierra
    sha256 "f00810821fb336bab4ca61dbe8f7a801b3697c64862062b7d666eaf3bbd4cc6e" => :el_capitan
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
