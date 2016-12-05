class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.16.1.tar.gz"
  sha256 "2f32783afcd07fb410a373bbb300b14ae933fe549ef4df0ca5bd5d3ed288b59c"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "7d80352ecc41ce787afddb5e76337926fa5c2becaeccf66c90ae055852a6e800" => :sierra
    sha256 "fadf90cc02adade6136c5a9bdc703fa00c585244a86ee83eb35db486062d82c0" => :el_capitan
    sha256 "8cc4c8b28388dbde6a54d339563e6e0a386710af4970f78f1cf2548ca6858f28" => :yosemite
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
