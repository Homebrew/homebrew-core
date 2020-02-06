class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.22.0.tar.gz"
  sha256 "4b948455d30203210601d8db330163e055910bab67829091d857121a05320058"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "d04d9d5b6103da39cc72ded96d173baf30b7729e2adfdbaef7c53605c76571f0" => :catalina
    sha256 "ad2bf7e1058488b6e914117de0e548956a241a8d0c793a6af96c20c8dfaa1747" => :mojave
    sha256 "fd383ed74cdc6a1eaee85807329c27e3c2df30a472c2ce0a2cb04a7035944c37" => :high_sierra
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
