class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.2.1.tar.gz"
  sha256 "58d59fc9023e277b476b689b688e7b66bdd6d3200cd3ccd543abfe028cc5fb7e"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "83c739a5b4ccb936060e76239b8ac0a3218b7c556056bf292cf1b035dfb9db56" => :high_sierra
    sha256 "1914e368b3d7c7471a36a09153cdb4124e3608482319c87f8b9e022116939471" => :sierra
    sha256 "87750301c4c24f980dfee5728b4a431bfafcf7c4ac079eff39b22c7f2e6520c5" => :el_capitan
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
