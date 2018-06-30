class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.5.1.tar.gz"
  sha256 "9876637b10ec1959bd9fe031c380e07a1a94e22b4f6db4001edf6160f485ed52"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "e07991349d48d7422149f10f0a2bdee6c0808a3f2e6d60b2b7ae02664a87a652" => :high_sierra
    sha256 "ac6775c5b320a74c4b16d8c17a64050bac61606c2ba147efe9afa47ae9a152c4" => :sierra
    sha256 "644bd3f6b90d4e537caf7d063a57bd2945f0cabdd7b6cc4dd60231a706a88594" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl"
  depends_on "python"

  def install
    inreplace "conans/requirements.txt", "PyYAML>=3.11, <3.13.0", "PyYAML>=3.11"
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", "PyYAML==4.2b1", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    system bin/"conan", "install", "zlib/1.2.11@conan/stable", "--build"
    assert_predicate testpath/".conan/data/zlib/1.2.11", :exist?
  end
end
