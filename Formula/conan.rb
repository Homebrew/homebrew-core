class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.18.3.tar.gz"
  sha256 "09a229ee0402ed23a30812df47c9b0c3f416eb19bb79994e0ade232fa6260446"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "c661332be846f175c61eb073591b8d00572897876685661ba02d802d60c8ea28" => :mojave
    sha256 "277b1db9f9f1c96900521ff659adb71e02bcaed369f144212141d7749dec478b" => :high_sierra
    sha256 "2fdfc9c189615180b0d625f47660d2dc01b8feb79171fa11634dce606a400fc8" => :sierra
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
