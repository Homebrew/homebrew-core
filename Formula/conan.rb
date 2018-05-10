class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.3.3.tar.gz"
  sha256 "9ba01055457f8826166c387e08602de985ca934d8ee602fbfa386e1e88f19849"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "617da6ada35c154c483399fad891277c1dc7485b7707dab011069946b98e5ca7" => :high_sierra
    sha256 "db13cdfe7cc0d56b2467220e2fa9342a8987feb3c01716e5caf2ba28250550c3" => :sierra
    sha256 "4f7a1cdf04d7d15709941054dbb47ec4d4006b3666af952a02c820a0b8af71f3" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl"
  depends_on "python"

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
