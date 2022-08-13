class Censys < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for the Censys APIs (censys.io)"
  homepage "https://github.com/censys/censys-python"
  url "https://files.pythonhosted.org/packages/aa/b8/17959203372592a4ab522875ef9a0315c45e10e70bcf7f066b427de6089e/censys-2.1.7.tar.gz"
  sha256 "cea64c98de8ba75a52028f0dcb3d2f23e874ac1e412c31f41d610ff23db189bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be774a8dc5f114256e4bfe044530cb787fd8adbbcefb8f205fb109fd7654b2b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7029f56b243e8fb4e287d4f065449d2ac273af34cc9ca701ba5a2e43eab8160d"
    sha256 cellar: :any_skip_relocation, monterey:       "d6588492eca9dbe415db01569461b8a7c9ec9dd37fbac08d7ad5dcd96a3eeef2"
    sha256 cellar: :any_skip_relocation, big_sur:        "22a26aafb2dfd2a77f36e13299c59ca821d20e846be70accfe298d8bf321b42c"
    sha256 cellar: :any_skip_relocation, catalina:       "e0585392517f742d060c680fb74d7a930c1b21667491ee4126380d35880bbc81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1545033860eeec359c1b953aac159576f11b49c0447fc8b227c32255535cda3f"
  end

  depends_on "python@3.10"

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/3b/22/53182ff2977aa653cb61f30592cbfb5d3e0764368c8eaa8ec096e6899b7a/backoff-2.1.2.tar.gz"
    sha256 "407f1bc0f22723648a8880821b935ce5df8475cf04f7b6b5017ae264d30f6069"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cc/85/319a8a684e8ac6d87a1193090e06b6bbb302717496380e225ee10487c888/certifi-2022.6.15.tar.gz"
    sha256 "84c85a9078b11105f04f3036a9482ae10e4621616db313fe045dd24743a0820d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/93/1d/d9392056df6670ae2a29fcb04cfa5cee9f6fbde7311a1bb511d4115e9b7a/charset-normalizer-2.1.0.tar.gz"
    sha256 "575e708016ff3a5e3681541cb9d79312c416835686d054a23accb873b254f413"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/59/0f/eb10576eb73b5857bc22610cdfc59e424ced4004fe7132c8f2af2cc168d3/Pygments-2.12.0.tar.gz"
    sha256 "5eb116118f9612ff1ee89ac96437bb6b49e8f04d8a13b514ba26f620208e26eb"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/bb/2d/c902484141330ded63c6c40d66a9725f8da5e818770f67241cf429eef825/rich-12.5.1.tar.gz"
    sha256 "63a5c5ce3673d3d5fbbf23cd87e11ab84b6b451436f1b7f19ec54b6bc36ed7ca"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/6d/d5/e8258b334c9eb8eb78e31be92ea0d5da83ddd9385dc967dd92737604d239/urllib3-1.26.11.tar.gz"
    sha256 "ea6e8fb210b19d950fab93b60c9009226c63a28808bc8386e05301e25883ac0a"
  end

  def install
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources
  end

  test do
    assert_match "usage: censys", shell_output("#{bin}/censys --help")
    assert_equal "Censys Python Version: #{version}", shell_output("#{bin}/censys --version").strip
    assert_match "Successfully configured credentials", pipe_output("#{bin}/censys asm config", "test\nn\n", 0)
  end
end
