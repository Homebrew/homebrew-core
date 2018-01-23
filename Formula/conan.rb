class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.0.3.tar.gz"
  sha256 "9df6da8f38f9088b65e472abd2439b2ab523c3747e72a1e0341ae87bf9a04d8d"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "fb87f0492781d6aecc84bc51fff0d53a2ff0845d81ec7c54328062e478c70ebd" => :high_sierra
    sha256 "43e42937cdab4edd20695231b83ef1b193e45538fc5b5ea8c4746c49958c11b6" => :sierra
    sha256 "f1cf78fa5c285bd2fe7ba45f7e04b1ddb0a4370becb364ab79ab6d0068a5d29b" => :el_capitan
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
