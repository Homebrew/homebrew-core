class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.18.1.tar.gz"
  sha256 "e5ac365785daded49be1e85606108c1fc551bba34084867e0591090e7277cde9"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "e0aac8eda1dc673cfec75c4a0f27268a30aa7bd870657dfe99dedfc27985c8b1" => :mojave
    sha256 "74abdaac136f95459187a3402f54e1a348ee356e4ad8a61a444da007a397e94a" => :high_sierra
    sha256 "2f76f5ca7eca79b24948a6105732fef444308df207b5044f813d54a1ecb46d6a" => :sierra
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
