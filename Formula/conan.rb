class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.11.2.tar.gz"
  sha256 "ec90cfaabb61a0f97fac89868cd4ba4eec5354625f07ec6f82a60fc06039ff7a"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "ae58d1ee752768308bf253a1d37fc56ffc585bde73a6130de3e47b6e17cfe0da" => :mojave
    sha256 "8f2317e061aed05be6288174da331c654ad522219e80e237f6a40bda0b930bdf" => :high_sierra
    sha256 "a27c6da0a9cb74e59948a379a86b507cd96db6310760ca9860fe0f226d5baeaf" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl"
  depends_on "python"

  def install
    inreplace "conans/requirements.txt", "PyYAML>=3.11, <3.14.0", "PyYAML>=3.11"
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
