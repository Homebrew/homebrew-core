class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.21.2.tar.gz"
  sha256 "62afb479834e221800bc9939f4dd46c947b6db592125ed18c7285763ed6dc450"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "40d4f001f1210a92f8239a0d6a1f6f6d4df9565670237acfd606428bec21f74f" => :catalina
    sha256 "378dfedb148ac2f387bb1a986f72718831e972086f897d42112b99fc7eb36ac9" => :mojave
    sha256 "d03141d756daf15b9eb08255967313c50206d4482589e614a0941b0f40935fbb" => :high_sierra
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
