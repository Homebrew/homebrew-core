class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.10.1.tar.gz"
  sha256 "a148dd438c027adb8dc04f3954164d39d12ea2da1cbd18f9d0d0ae2234ac82d4"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "fe760a649a088589e6502e2485b25c954e5157dadf2bc448af456c496ae462a5" => :mojave
    sha256 "9cc5a72a798fcb98ecfa2551e8b6ef9547d91ec269d52dd6eb5435fce2f76612" => :high_sierra
    sha256 "c9d002450fa0b5169ae241ae1b3102a27901b0ec73c727038021dab20cca6888" => :sierra
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
