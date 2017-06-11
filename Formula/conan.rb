class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.23.2.tar.gz"
  sha256 "702cda9ef1163457150db9156ba27dc335e611f9afc0819bb3054b44565957ec"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "8e027c4ce0f57b49fc23523f33ca583b1ab5f78c793e42aa84e0da0153bd2c36" => :sierra
    sha256 "261f1e82cb45e33e10cf94ad6eb57f7fb91c00708a09104550cc84d878b2442a" => :el_capitan
    sha256 "793213487b7aba550b6e6ea43235688fcf231d4dcf3ed86e34a3bac7dbed95de" => :yosemite
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
