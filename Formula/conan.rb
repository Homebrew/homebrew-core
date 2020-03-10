class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.23.0.tar.gz"
  sha256 "0f670f1b7d14fb6edf106971651f311e447d3d6d09cdd3c59ff84fae4fcb79f7"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "63fe570a859f7fccbaad50ffc1cd111e784ab59f5ad916028609c7859fb49eb6" => :catalina
    sha256 "b10d7f1f181bc2f9eea9be55548494cce2d6d5dfa2c74cb4adc2dca309095b8b" => :mojave
    sha256 "f7b94545550f505859a82dcdfac8a798c826dd4be9b182e08515ae90f678280d" => :high_sierra
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
