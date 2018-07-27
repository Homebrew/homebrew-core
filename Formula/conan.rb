class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.6.1.tar.gz"
  sha256 "fbc59dd4c20a9940c72b0a415892d38823a7e2f6f7a7ee6cd84fbeb9b7a2b10c"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "3ed126ba572f790c0c974d8f891bae8af376c01ec76f8caf0d3476eebb636773" => :high_sierra
    sha256 "727c083467687787661e216a6536876133a85ce4ae06eea83b27a91bcfa8cc2e" => :sierra
    sha256 "5d7ca449f3424b7461d71e7cfe2959c1e1486c3444a0c757d0e7ad34e89f7879" => :el_capitan
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
