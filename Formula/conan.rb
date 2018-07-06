class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.5.1.tar.gz"
  sha256 "9876637b10ec1959bd9fe031c380e07a1a94e22b4f6db4001edf6160f485ed52"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d40610073122aa5e0942d9b7d14fe5d564d6e0d39fbad076c051df383c476021" => :high_sierra
    sha256 "a14a221f176379efd1dc2f2b98243c5b4c9a8a5a032a17bf5fdc102de1a67d2c" => :sierra
    sha256 "ed8b2d3d752a094505d8f446fb1d2b2273e94f22689ae2bfcdda45cada1c07f6" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl"
  depends_on "python"

  def install
    inreplace "conans/requirements.txt", "PyYAML>=3.11, <3.13.0", "PyYAML>=3.11"
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
