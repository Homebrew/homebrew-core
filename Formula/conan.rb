class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.18.0.tar.gz"
  sha256 "726c7df28319f2fff39195b46253e9a9330fac0ce1440816ca9da97fd0644aff"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "8bbc6d2c8c58f5813ac890340351849138d0ea3b5dc6be79320e6bd3c2a7612f" => :mojave
    sha256 "e789b54e79c07ec354232db1fe1a3585a05bd55fc58b79711f8c371fb567c562" => :high_sierra
    sha256 "f4a83b8ea3ffe4738d32b2dd0755d2c58f5faf8975b9f209ef0e51c8e89da7c7" => :sierra
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
