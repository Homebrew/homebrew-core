class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.26.1.tar.gz"
  sha256 "45d6e6c92df45c92e1312a746cb6bbfedf030d9d8039c0b6251b5f7d8d3e6a1f"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "a8e41e2ac19d5de4a45fc45f28ed846414298a5181f8de5d7748cecf9020210a" => :high_sierra
    sha256 "a14951f79fbce377ab7a4811404cbcd68c1c6399638f521d34159bde63d932e7" => :sierra
    sha256 "de6866b1d9e285569111128f158991541e6509ee34dd4d63243eef3b7cb37095" => :el_capitan
    sha256 "6b8fcb3ec2db3e0e83e01f7245d1d0165197a478175d04717e343c287956f50f" => :yosemite
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
