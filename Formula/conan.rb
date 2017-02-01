class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.19.0.tar.gz"
  sha256 "6003d72eddf81d837eff1d411040c7d2d6dac40deeeefa65ec3679af5aa5e1b9"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "184bb6da45dd0afa2e8ef15413cb5ab153a4847a1d8ba06d90701e2bcb5d2938" => :sierra
    sha256 "5cbba5761c9b33dab61ebb4c9ac90c2af2f8d7e0b1b209f2e44ba54f4f298bfa" => :el_capitan
    sha256 "00178deceb2efe70eaffe36288035da66625ccc599c2954cfcf468b2b6d78c44" => :yosemite
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
