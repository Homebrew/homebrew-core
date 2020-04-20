class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.24.0.tar.gz"
  sha256 "fe7fc766d3ff4997a700d141485ba7dd2768cf78eb710fed413a6ccea8b7f9a1"
  revision 2
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "ac7b328b561f305c935dd39aa832b0267fc8bc2d86c5754e20d0118ed04d46cf" => :catalina
    sha256 "43a9d12b8fbc9e2ca5afd5d2d6d65690cfc23346aa4b2ae34dfd57186019d4b4" => :mojave
    sha256 "0590eb392a4345dcb34675bc0825eb150094e2335c3270d9a56d32b7f0d0b93c" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "python@3.8"

  def install
    venv = virtualenv_create(libexec, Formula["python@3.8"].opt_bin/"python3")
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
