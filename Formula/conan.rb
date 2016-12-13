class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.17.0.tar.gz"
  sha256 "2e9df81141a5702814518209112e92cba76cdbc55f0916c15adaa768d85f43c1"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "f7bf7a7ed9eb1895df95c8523e4ada60e1ece21a22dbd3364eece5892fd487f3" => :sierra
    sha256 "93e10f2632a477a98fa7ff92383e12eb0774b187520d3206bca4994b8e0671f4" => :el_capitan
    sha256 "995fec638cd12bfdf43ad236197672ba4955ea556e3a596d65b712565f051947" => :yosemite
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
