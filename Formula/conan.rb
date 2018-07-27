class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.6.1.tar.gz"
  sha256 "fbc59dd4c20a9940c72b0a415892d38823a7e2f6f7a7ee6cd84fbeb9b7a2b10c"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "fd05e4a432b1e68738ba016aea909271731766612a8d5db26af91a83f5939819" => :high_sierra
    sha256 "25975441dcbf7c9c3a7d3340053dd55653f99a54d5941c54424d8932f853fcdf" => :sierra
    sha256 "069fb0a792e25e6282d05d1d2925a7c12d83987b6a864c7f695fe2398506894e" => :el_capitan
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
