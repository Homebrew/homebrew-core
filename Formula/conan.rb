class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.21.0.tar.gz"
  sha256 "c820ed81dc07b7373b5a5a9537d85896435037fe9b35d43052f35ef05a69f411"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "9710d9a0a44f6a1359deb277d19c4276e211a0eed295058ca55517dd8d1d740b" => :catalina
    sha256 "c66c07b3d730521b91f712b961449581ccc2583e18f5ebb1e75f9b9e5c9db8bf" => :mojave
    sha256 "e6566da34df4fee485ef80fbcbc94a2238ad2a10ff0e6bd89de655ade3cf14a8" => :high_sierra
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
