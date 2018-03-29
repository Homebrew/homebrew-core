class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.2.0.tar.gz"
  sha256 "f95b9f3c54a41225ded97aa806b5b92a05cfdc9b566718a2298952fa77d482a4"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "d108102f88b9416069011f5aa2dea4ebf6a85086be790210ca4abd9caab85e83" => :high_sierra
    sha256 "8a1752d8e734cc262e25544e0aa824aa4bc117c4e6827dc0101c3817a87e5355" => :sierra
    sha256 "92e9f778b08a9098632cc921066067608b923c7ab475f0cd3d6046f28fba354c" => :el_capitan
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
