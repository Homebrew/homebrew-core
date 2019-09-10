class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.18.3.tar.gz"
  sha256 "09a229ee0402ed23a30812df47c9b0c3f416eb19bb79994e0ade232fa6260446"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "7a33a82decd89d1547b7fb2f137934ba9ed794f7f8f671d772b7acf0adf4db25" => :mojave
    sha256 "61e4302c8c888738519e969bd51a875b3febccd1c241aae974c4b6d2f6ab867b" => :high_sierra
    sha256 "bbeed7494d50aee4a5e40cf34e019e5566be96ed2a18af8f224ff25d2c5f4b67" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "python"

  def install
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
