class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.4.5.tar.gz"
  sha256 "36edf0abd51717a5feb7e7c0c4d6d45b38d08b7e94621ddb9d3a6a3adff2f5d5"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "5621d54b380d223a8f8769ea17efa0f179820a24bab1d766ad2fe1f21f0aceaf" => :high_sierra
    sha256 "c2ed65d56e9c7d2d10e02d3bae88b6d0af91f23573d5e63a2122369343028551" => :sierra
    sha256 "e81397724b835d8e2f708f86b403b1546d79dc9b174a23d02f1628170580d014" => :el_capitan
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
