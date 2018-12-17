class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.10.2.tar.gz"
  sha256 "c7e9bd3076eae48b8416274233a7343f12ba440fe2a35b78d0065c9707ecd6c6"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "778b361fce9c68007d0dc94909f547036c2c6886539f4b2652d3effcc49c43e1" => :mojave
    sha256 "061f23d8886a335e7a1759c07b6b194a418e64d96c1d0c094bf089beda1e1b45" => :high_sierra
    sha256 "bb8077858e6cad744d5805bc362ddbc7287e1a71319f9cfa557138aab9104f06" => :sierra
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
