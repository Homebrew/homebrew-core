class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.3.1.tar.gz"
  sha256 "5c74782d579f0a1f2d043332d304d949ba1688c5dfa581efaf54ebf88209e22d"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "2687cb16a7b2d453189db9bffc06ff1eb118ab07dd4015e7f92d51446963152e" => :high_sierra
    sha256 "c9702d8e42d9761fd134dd1fbb5f5ba9486a04a379a2727934e0c0191d753d30" => :sierra
    sha256 "0bc600a6385ce5b7a1dc23c8df5f72ac1e860f6de423774c9b9ce5223e4d22f7" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl"
  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    system bin/"conan", "install", "zlib/1.2.11@conan/stable", "--build"
    assert_predicate testpath/".conan/data/zlib/1.2.11", :exist?
  end
end
