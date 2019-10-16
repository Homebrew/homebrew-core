class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.19.2.tar.gz"
  sha256 "1b824f14584a5da4deace6154ee49487faea99ddce3a2993f6a79f9a35b43d64"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "51446e38131cfa12fc060aafe4f16358e9e49036d0fbe6b59bbfd835efc84a50" => :catalina
    sha256 "635e41e8f564891268b2b31481ab821034fcaa561e8325ed1357eb0ebace49ac" => :mojave
    sha256 "9dff047a80c4b21ca4ab4f1bda6d6581022baea4cf676f270e81334f33b35afa" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "python"

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
