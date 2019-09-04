class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.18.2.tar.gz"
  sha256 "5e53bd4e1db4581502b1e327840a458c830d2322b1b9d20630212e061d706390"
  revision 1
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "5e98423e591025d7399794980e4eac216e546a9159cda9a2c5d304b320b261c9" => :mojave
    sha256 "360e7dfdf7f76d2b9046c0be90e6ab42da26023be2fce2aae2984164bf5324fb" => :high_sierra
    sha256 "d012eeeadaec008f1248daa2596dae45dbc13a057916fe447bb0a7ac3aecad74" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", "PyYAML==3.13", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    system bin/"conan", "install", "zlib/1.2.11@conan/stable", "--build"
    assert_predicate testpath/".conan/data/zlib/1.2.11", :exist?
  end
end
