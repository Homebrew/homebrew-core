class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.4.4.tar.gz"
  sha256 "54a4c0ac9e06cc802212255f67abedcbd63e266e259d907e784000ea9134e13a"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "a47463bfd8400725d753750b4133564efb2bc9bbb3ebc6e0831d941b6cfee6ca" => :high_sierra
    sha256 "d5ce6973f535b39bcc5585c1b41d1a8590fdcf3b1bb5a991df2c4edce5aa6b82" => :sierra
    sha256 "09d850ff96acb019d0a76843fd578e534d39b81fd546b60bcc5e0f8e99200aa1" => :el_capitan
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
