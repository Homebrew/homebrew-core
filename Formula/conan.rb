class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.25.1.tar.gz"
  sha256 "99713b7bd7d0e33f4dc7716aa89849dc580ddfce9e89ac22063b88eea514d302"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "de19c48fa67582b8d827a8b51430869e740e751fed51fe2c42af7a9d2e52ade7" => :sierra
    sha256 "fd91a280b394db7b4cecf7a957e276f3b6cc68f13b695a174b1bd72a4b8218ae" => :el_capitan
    sha256 "e139c3ed7090748b5fb4af3ef2c47b8bbe5d5db3a987d2a1cf8dd840e78bf0ec" => :yosemite
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
