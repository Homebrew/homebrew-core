class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.15.0.tar.gz"
  sha256 "bbb8b211b2ee6797a3933547917dc3da2cf091999f0b8dcb600fc3f041af2216"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "3d967dd004acf572d48fe54e0051c0a6d3491a59d71197b09de73cfd7560f458" => :mojave
    sha256 "416cb1cdd7b64bd29125cbeb83a56e81db8678241889b9c4a5941e029c3f88b4" => :high_sierra
    sha256 "145e7ab32df6de4a9f2165702b1c50356b5fa8359958625f6d0cf680660ce55a" => :sierra
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
