class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.15.1.tar.gz"
  sha256 "85effe2d15a32a34b64f9d30186e34454f2c5a0bb9e696f3cfbe18bb46aff5db"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "7327b43ff31e6e169c28f8c32d90f44e4596469d5fe918bd9918aa47776bcf11" => :mojave
    sha256 "4810f87051868a904169737985f66751968661b69a78103678bb8e2684e1a557" => :high_sierra
    sha256 "21c9b20f3b7741934dc9b0b2fdc67354466279164816b8afbdf6d1870948bd94" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl"
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
