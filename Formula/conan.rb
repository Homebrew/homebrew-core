class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.19.2.tar.gz"
  sha256 "1b824f14584a5da4deace6154ee49487faea99ddce3a2993f6a79f9a35b43d64"
  revision 1
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "2e7fc5de103497d21d49e40b4d51930980031d82acbd5984c655785903a8f02b" => :catalina
    sha256 "4f79aecf6c0faf883db162d0a167ffdf59ce3eea5a528e318e6d63120fa69558" => :mojave
    sha256 "1f74449d1ef308677f5b80a22112acf7ad3a0fd7259692c8b036c1272057ee31" => :high_sierra
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
