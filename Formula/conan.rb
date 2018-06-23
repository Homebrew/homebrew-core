class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.4.5.tar.gz"
  sha256 "36edf0abd51717a5feb7e7c0c4d6d45b38d08b7e94621ddb9d3a6a3adff2f5d5"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "d639fd446a474a9145f9a09b5551530409d98bf53ae07b67fce0a2a29c6cfcf2" => :high_sierra
    sha256 "5bb1b953ed0acda275fab4f609020a7c09d1b1acf43627b629ba413d5fe7c76b" => :sierra
    sha256 "77a353f818ac09cb39297000ef739727be9d949fa19287af7f2e09da42d51b66" => :el_capitan
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
