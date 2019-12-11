class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.21.0.tar.gz"
  sha256 "c820ed81dc07b7373b5a5a9537d85896435037fe9b35d43052f35ef05a69f411"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "71b95e6fc772b3350138a3ac3781ada5f1c21787ef9cef8377f095f0bb88d10f" => :catalina
    sha256 "17370629b0954e75456d9f5bea7817fe72f65794bb512ad02c3a6da04f920376" => :mojave
    sha256 "0e37724deb0e642b3b5b3cfeea59e702f5d23d78a488d36688b3c3ecfb58656f" => :high_sierra
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
