class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  homepage "https://www.breezy-vcs.org"
  url "https://files.pythonhosted.org/packages/e4/93/101bb70d7e6c171c7a3a99d50d9f9b64a17a5845cfd6c8ecb95d844bac68/breezy-3.2.1.tar.gz"
  sha256 "e0b268eb1a28a2af045280c37d021ae32d7ff175f4c9b99f33aad7db0b29d85c"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "91ac24be8f4fc563cff558d5d4d08e176235a9ad5510c0ecf2af6790e4ecf27c"
    sha256 cellar: :any_skip_relocation, big_sur:       "b83446c114ad82d91da5614176a13a4991da60179e83d2f24e17c3d004a30e46"
    sha256 cellar: :any_skip_relocation, catalina:      "4cd007f23c658ae903a52be4454c29b82abd70d5a43aabc61b71ef6b2dd710c9"
    sha256 cellar: :any_skip_relocation, mojave:        "7643ca66430fec0bb7d285f76a0912622fb50b171b264a6beb695f414c765796"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c375279c3a764e7a63935d7f3d838916bbcfab732c61cf2ff6dc3fc085b63ac2"
  end

  depends_on "cython" => :build
  depends_on "gettext" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.9"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/85/f1/eab86c0058d2195ec084dd200c3e4179871e13e4f38f17ff3f6c7dee3c56/dulwich-0.20.23.tar.gz"
    sha256 "402e56b5c07f040479d1188e5c2f406e2c006aa3943080155d4c6d05e5fca865"
  end

  resource "patiencediff" do
    url "https://files.pythonhosted.org/packages/90/ca/13cdabb3c491a0ccd7d580419b96abce3d227d4a6ba674364e6b19d4d67e/patiencediff-0.2.2.tar.gz"
    sha256 "456d9fc47fe43f9aea863059ea2c6df5b997285590e4b7f9ee8fbb6c3419b5a7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4f/5a/597ef5911cb8919efe4d86206aa8b2658616d676a7088f0825ca08bd7cb8/urllib3-1.26.6.tar.gz"
    sha256 "f57b4c16c62fa2760b7e3d97c35b255512fb6b59a259730f36ba32ce9f8e342f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    brz = "#{bin}/brz"
    whoami = "Homebrew"
    system brz, "whoami", whoami
    assert_match whoami, shell_output("#{bin}/brz whoami")

    # Test bazaar compatibility
    system brz, "init-repo", "sample"
    system brz, "init", "sample/trunk"
    touch testpath/"sample/trunk/test.txt"
    cd "sample/trunk" do
      system brz, "add", "test.txt"
      system brz, "commit", "-m", "test"
    end

    # Test git compatibility
    system brz, "init", "--git", "sample2"
    touch testpath/"sample2/test.txt"
    cd "sample2" do
      system brz, "add", "test.txt"
      system brz, "commit", "-m", "test"
    end
  end
end
