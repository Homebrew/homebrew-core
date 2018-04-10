class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.2.2.tar.gz"
  sha256 "6efd2ec1516906326b7818c47ec0710ab5d34206fb7cdf3a0c6b3a61d1e64baf"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "48d55e1e56c25e496641bd44939b814c61eab2946576cf06e2c50ac48d086f8a" => :high_sierra
    sha256 "8472b03dee0a948689dc15c7eab9651b904e617199bb74e2713da9094d1390a9" => :sierra
    sha256 "517f2eafcc32c5b9468e5a0f9e7c8a0435d639030cfcb5b7c572660755f8e1ac" => :el_capitan
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
