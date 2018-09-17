class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.7.3.tar.gz"
  sha256 "f0ea9bd04120eaa3ad2eec3096c61dbf6392e50c1aba20e90c387de06b4f4d44"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "f5f1a993dbbaf587874359c03f790bfabbf02a6625005ccb009f39f19586753e" => :mojave
    sha256 "f7c5b47eef23372e532a70cab807d36d81f9fdbb0dc565d29937465d52c7a8a0" => :high_sierra
    sha256 "3112ee994e830eba609c4e7f0ea978e33e90048433c01f3c7a96e712688988f4" => :sierra
    sha256 "68d93c5006e1f29539b014a626a2c9cf3c7362577d3d794a56e8df43cfc47f69" => :el_capitan
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
