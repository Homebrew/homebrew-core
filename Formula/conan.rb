class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.22.3.tar.gz"
  sha256 "cb38e0926dbb2605ba3ae86a5f7bd36c155c7bd449baa0863bcc1051f4e546b1"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "1b6956e11c5594535f4e5f04c062032cc6dc8b5195248d6efec1634223d2cfb4" => :sierra
    sha256 "1a44b20dfbc846b26b06587e3a1a28ace649a03ec08fad058c18f321a7a473ba" => :el_capitan
    sha256 "6b5c686f5f0a67ae5ad23a143086f289ed86f93a0c689909b67d1078ed0cc748" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libffi"
  depends_on "openssl"

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    system bin/"conan", "install", "zlib/1.2.8@lasote/stable", "--build"
    assert_predicate testpath/".conan/data/zlib/1.2.8", :exist?
  end
end
