class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.14.3.tar.gz"
  sha256 "9e3562bbfd0c247b05f5c7658785723c43fcda0168439e0d7089f1f2cbca8dbe"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "c134619a47f2bd5746b3b40ae7c503cf05777f2a5727c6611da7eb8ac1ae62e6" => :mojave
    sha256 "ea1d9910f8b0363eb811dbb80ce81e7bab72842bb0a41bf418f12328a84a36da" => :high_sierra
    sha256 "57280a7af4aff312b96d5b60dc888727bcec232c87896bbf7616f8340a8ad852" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl"
  depends_on "python"

  def install
    inreplace "conans/requirements.txt", "PyYAML>=3.11, <3.14.0", "PyYAML>=3.11"
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
