class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.17.0.tar.gz"
  sha256 "12a26202cb3d2f6f5cfafb6cf0ee8a2940d1b507aff73fbe66e7ffe94f5003db"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "55ff6d9d88ce809c76bcb1146d9dc4ebab3f02b1f971e69ad7b2a44f8bc90774" => :mojave
    sha256 "0e47114ce7b29e2bfe308e41f93b44f153518cf59146f04faa7ee41a8c3f51a5" => :high_sierra
    sha256 "f73e1c7d9a92486240b2ffe0cd2030354feb02cc3a95e00842de3a234be07864" => :sierra
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
