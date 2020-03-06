class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.22.3.tar.gz"
  sha256 "97887da0ad242024dad5f266e8f6ebfff267e8e426e5c56d79abda37ab108512"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "6b3d675090e53aa0030b57fcad42cdf7ed3cec169a4f82e048e77b8fd866befe" => :catalina
    sha256 "a0f66c9297cb3b8355275cb155ef1e0f3bf36f67e07c496defa115c373ec5067" => :mojave
    sha256 "1890b44353f00dea04054958ef54b2e2d3fdc396153ff3b6983e3be355026bcb" => :high_sierra
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
