class Censys < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for the Censys APIs (censys.io)"
  homepage "https://github.com/censys/censys-python"
  url "https://files.pythonhosted.org/packages/73/34/4a770e29e823242e8e9c8d9456193662754b9245d061686b7aea6f9d151f/censys-2.1.9.tar.gz"
  sha256 "caccc151083232c9ea989b705c676a5629743b51e5d8d3998012be08bb921001"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75c237ae13f9ecfbc96c29c6b773af8bdbff91f03f873d4858eb51e91657ce1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "599e7bf259e4286a1213ad6d8fc80966bf8d03d4e5fe4cafd58987b23013288c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8dddc8cc613700c1b1430175e56044468c63518741048fd017ab0ffa86b7ebb"
    sha256 cellar: :any_skip_relocation, ventura:        "7889dd589af26f1eefa24b1e7bb3480b2a2b4d68309beb8e103394c8e3d4a9a1"
    sha256 cellar: :any_skip_relocation, monterey:       "c040cfa9c6f7d3b8ae0c751f2c89dbf3156aff51d515dfeafc643d171bc24ee5"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b7d0ae329c1015f55c8a6c706eb3a800aabfb9e41e2255316532584774d2a93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb1a229eb55899b13e3bbc7ecfb61fb69866a0540e3a01384675239a97ca81eb"
  end

  depends_on "pygments"
  depends_on "python@3.11"

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/11/23/814edf09ec6470d52022b9e95c23c1bef77f0bc451761e1504ebd09606d3/rich-12.6.0.tar.gz"
    sha256 "ba3a3775974105c221d31141f2c116f4fd65c5ceb0698657a11e9f295ec93fd0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c2/51/32da03cf19d17d46cce5c731967bf58de9bd71db3a379932f53b094deda4/urllib3-1.26.13.tar.gz"
    sha256 "c083dd0dce68dbfbe1129d5271cb90f9447dea7d52097c6e0126120c521ddea8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "usage: censys", shell_output("#{bin}/censys --help")
    assert_equal "Censys Python Version: #{version}", shell_output("#{bin}/censys --version").strip
    assert_match "Successfully configured credentials", pipe_output("#{bin}/censys asm config", "test\nn\n", 0)
  end
end
