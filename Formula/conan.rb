class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.29.1.tar.gz"
  sha256 "18a35f66df37c022f4589fcbe173431ff8d2f3b3e7f50a06b3c638096cd8e223"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "b74923d9883759f5970ab8146a99ad38848c6f076a21378bb150200c7cf71cec" => :high_sierra
    sha256 "2f1b2e5c885b9a32ece6da0a74f5be646b13d18c53fc59093b598f7dc70dca55" => :sierra
    sha256 "0a316f28281292b035ab30d2702b3df1a0561a92dea15723996def0c99178286" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libffi"
  depends_on "openssl"

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    system bin/"conan", "install", "zlib/1.2.8@lasote/stable", "--build"
    assert_predicate testpath/".conan/data/zlib/1.2.8", :exist?
  end
end
