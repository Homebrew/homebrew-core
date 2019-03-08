class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.13.0.tar.gz"
  sha256 "cc090c2f0129c0752ee531fc721b1f14ec5511206fb4182764ed84fe6bee79de"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "b16dbe7fe27e9c858d2649512797efb6bee62d0e5458eda13d6b6860612a6213" => :mojave
    sha256 "a9845a83301a32f5535b707e4832b55e719718dd81d2e96b8015f904a61808ad" => :high_sierra
    sha256 "98e3be25676b30ca45368abde71a5bf487fc0dfb2c485e9d72ecd7922fb8601f" => :sierra
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
