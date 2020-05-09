class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.25.0.tar.gz"
  sha256 "0cd4ea9be6c3882a7d989bccc6b9fcf5d519276670a60d2e2553ebf44ac93406"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "f94b6d91125c1ceebc1a38d9d02d8af68ed33b2a81c839b8f75d29c6f5f95fd4" => :catalina
    sha256 "4876d1ca624e009d169a609ec7ea09471d03b4ee9d95ef99906270e5a2362708" => :mojave
    sha256 "76bde7389a07ea427763ef06dd2666c519a7a16cd0a7d1b67cdc527a0f8a4cc1" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "python@3.8"

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
