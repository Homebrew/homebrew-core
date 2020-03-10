class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.23.0.tar.gz"
  sha256 "0f670f1b7d14fb6edf106971651f311e447d3d6d09cdd3c59ff84fae4fcb79f7"
  revision 1
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "a2b829b259eebd57153956309485f3d7ff01586ad27ff3dd04af18c613ab4c15" => :catalina
    sha256 "85af0ee6c31bc850eaae1762d247d27cf49df11e021a1c949100655d4b6fb83f" => :mojave
    sha256 "e4e455dd6212ba65583a2df45d714d2b9480e0f7c9f8c7d362f06aa525e5836d" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "python@3.8"

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
