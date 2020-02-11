class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.22.1.tar.gz"
  sha256 "4ee6f95a34b76d90703efabcc61d0cb64cf21570d31787aa4c7d96b8dc4ad938"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "cf1e72e91bf92a1c836e10ab97461bbcba812a16c18e8e57ccdc4d3d77905473" => :catalina
    sha256 "31d333877ed85ebe729fa2e56bbe7355b22c29e9481564e024690ad7eacb69ff" => :mojave
    sha256 "b36545c5f7c4261ebdc148362ed59a6cfed2a3d2d70d859ae6d87cfad71a26c0" => :high_sierra
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
