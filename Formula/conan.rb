class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.0.3.tar.gz"
  sha256 "9df6da8f38f9088b65e472abd2439b2ab523c3747e72a1e0341ae87bf9a04d8d"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "b0972c4d815e46ba0c282a6180b8f9d952b72f3027a363d1de92a6908c58d3a9" => :high_sierra
    sha256 "93c4777bfd1df875b2b1d8e726ea305856d20f351efa9244455bc23d7af59999" => :sierra
    sha256 "2fa03e58ab978257ed28972f84a582d306bacfff6053a10bc20b36e96f6032cf" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "python" if MacOS.version <= :snow_leopard
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
    system bin/"conan", "install", "zlib/1.2.11@conan/stable", "--build"
    assert_predicate testpath/".conan/data/zlib/1.2.11", :exist?
  end
end
