class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.24.0.tar.gz"
  sha256 "fe7fc766d3ff4997a700d141485ba7dd2768cf78eb710fed413a6ccea8b7f9a1"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "ba2bb5f4cff6578ec8da1fca0308ef2cf071ab5645b17b573c9cd221e1452ff9" => :catalina
    sha256 "bbd877aa41ec793191f097d54ed51c4450e7e24f655f08cd6306b420bfaae6b5" => :mojave
    sha256 "3f32ebfa284204d60a69ec137f50098a46f460b680f6a4457a41bc00db454c88" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "python@3.8"

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
