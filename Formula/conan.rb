class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.2.0.tar.gz"
  sha256 "f95b9f3c54a41225ded97aa806b5b92a05cfdc9b566718a2298952fa77d482a4"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "e39550875a873b2770778e112b7c57d65b71a49d7094d320c1ad5dc18f916ba2" => :high_sierra
    sha256 "f4125dde426824dd981cb3df6ba41ed2ddc851e3fed11f308ea88845f4d74c47" => :sierra
    sha256 "a2c6abbe798dfa293787d0e038c840cde4aba912fd59aff76864e0064071f87d" => :el_capitan
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
