class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.4.1.tar.gz"
  sha256 "2922500d598f9daceec2082eb334c3173a28d9be80bd903858a929aa3bb720ed"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "beb0ca87b9cd3064e5aea3e63cef57f8172b11eeceeef573354a1f9cecbe839c" => :high_sierra
    sha256 "81ceb308b802cd07a004459e87981f2964dfaa55f0f7ad39c640d86d25f3e0c4" => :sierra
    sha256 "f6b7b80f5d4a7f391ed25eeb3affbe8ccb178be42669d0789ffeb5cbf3248355" => :el_capitan
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
