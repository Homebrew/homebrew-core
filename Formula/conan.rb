class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.13.3.tar.gz"
  sha256 "8401c7db8fd909d93e1fb1d5f160b6d301ff538b145b2e2a6331edbb6651e173"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "965989d2e3404836dd1aa12433248af22dc259e5b6eba4a6ebf01730a5364d7e" => :sierra
    sha256 "252bb5ce3b8820f6cb49e58b821f4f5130461b1680e5d5d7178c9c6e956c0318" => :el_capitan
    sha256 "f39d72a141ed5ecf199f1c9c5fab55600e865d2e409723c342022486693390fe" => :yosemite
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
