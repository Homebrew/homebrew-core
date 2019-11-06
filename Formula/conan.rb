class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.20.1.tar.gz"
  sha256 "6f5f2a75c50fda7fe6d87bee5187400a7c41939e7c2f5fd3489c9d99790db779"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "03fe6223dfa4d156419ae7820bbb77bd813e86951456c84ca8831218ffab2336" => :catalina
    sha256 "359d90b40ee8f84ee97b1c0c1e67229f48c657729c87d318d5f5f75c3fc5d62d" => :mojave
    sha256 "c0e3f2850eddaba19092c093273ddbb966e31ba3168cd35fc2e4f8da869e225f" => :high_sierra
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
