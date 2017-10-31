class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.28.1.tar.gz"
  sha256 "3a8646f59cf56a9e5652884df84e2560dbcbcf90d24a796044769c65c205fa38"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "f3a8091cbabe0ca7e650cd7bda67827f5e4cc99ca1201dddb207517d4aad7f16" => :high_sierra
    sha256 "e74c49816cc5d352af45c9398bce92257b11a491917978f17da3bb9284f1d781" => :sierra
    sha256 "b56a03cfa5d749e2cdcce01a22158790a27086d760528bb2d6d7eb95dec68307" => :el_capitan
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
