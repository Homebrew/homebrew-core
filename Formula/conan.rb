class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.13.1.tar.gz"
  sha256 "f06fa45e060fbfbf4f154c231bf809325a8ff49ca4fd3bb026474cc1d1d8dae9"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "692c6db14ea912e634fde29ce2798624c809669052965f4d13021a42569aab8d" => :mojave
    sha256 "f157b45b8337c5c227304179160b52d19c4ea5e487517221526f9669a64a50f1" => :high_sierra
    sha256 "cf80912f3a995f7c4df1515b071ea336ce9c3042546476e3b40907344d840a64" => :sierra
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
