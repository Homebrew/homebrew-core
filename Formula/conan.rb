class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.27.0.tar.gz"
  sha256 "a92bf05e1259ad547414a90369b5a77d867963a774ae88e2117f39dd147c7cde"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "00de66ff8b942c02adc27efdf864b6e2bb3dc84588ff2794bbd2b3d9d3407e72" => :high_sierra
    sha256 "db8b87350e462d64f40dad22c5efe11f3c578e8c674c18772bf33952fc9fc0c8" => :sierra
    sha256 "59c0647c5e096949a9057f3cb0d339d929cab44884417aa34ecb1ff9d50c0de8" => :el_capitan
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
