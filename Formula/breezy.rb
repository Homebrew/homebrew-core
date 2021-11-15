class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  homepage "https://www.breezy-vcs.org"
  url "https://files.pythonhosted.org/packages/e4/93/101bb70d7e6c171c7a3a99d50d9f9b64a17a5845cfd6c8ecb95d844bac68/breezy-3.2.1.tar.gz"
  sha256 "e0b268eb1a28a2af045280c37d021ae32d7ff175f4c9b99f33aad7db0b29d85c"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce18d109ba318dd50c753cd3d02fc90ad6df9575ebdb7c515a1847dfc931598f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbec16ab9ab4fec8b1f9e68bbb11a190e066c9201a538da5923996ef366f30f9"
    sha256 cellar: :any_skip_relocation, monterey:       "9ffbad5b832bcd48b2622fabbc1c8677716046cbbcdb44a94b7056d988b356dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "cec1b7917f72dd243bb066e794f94164e4c626b1034900945f5c47b5cf0c0615"
    sha256 cellar: :any_skip_relocation, catalina:       "8da239d61c5e5c0b2b767fac9ca5c76e282681dc74f71b6f61223cea93f2aa22"
    sha256 cellar: :any_skip_relocation, mojave:         "6f28d8c1bf39889ea05179529c3d1d1c4b2b9076ba859111d881f771635e2be7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8eccce30623dfdaeaa0761d98739153c986f27d05f177282e7c3d8aa49182992"
  end

  depends_on "cython" => :build
  depends_on "gettext" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.9"
  depends_on "six"

  conflicts_with "bazaar", because: "both install `bzr` binaries"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/7c/d2/a361b4831494531d5112e000d92762fc2926ed45ca7f9e9013f2e90c011c/dulwich-0.20.24.tar.gz"
    sha256 "6b61ac0a2a8b1b1e18914310f3f7a422396334208b426b9de570f1de31644cf1"
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
    man1.install_symlink Dir[libexec/"man/man1/*.1"]

    # Replace bazaar with breezy
    bin.install_symlink "brz" => "bzr"
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
