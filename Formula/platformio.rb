class Platformio < Formula
  include Language::Python::Virtualenv

  desc "An open-source ecosystem for embedded development"
  homepage "https://platformio.org/"
  url "https://files.pythonhosted.org/packages/b5/b6/832b92113764feae278376dd0f39f0a3d4321c24b9ff1ff9c9777ba23b8d/platformio-4.1.0.tar.gz"
  sha256 "4552086d82fb4d7022abeb620499314249548d084b37ddf446a7ee3099b13c21"

  bottle do
    cellar :any_skip_relocation
    sha256 "f769790bdb0f71864d99da08e650635476a69d56a2e291cca76696d2cfbd3a6c" => :catalina
    sha256 "d4a008cd54553a7830f8b78029fe44b67179f6fb9676667f34f3dc63b4886413" => :mojave
    sha256 "1313c81f8906aa6c6646c3175c05089afbcc0260a18ccb957f2ae37d666d9fbe" => :high_sierra
  end

  depends_on "python"

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/c4/a5/6bf41779860e9b526772e1b3b31a65a22bd97535572988d16028c5ab617d/bottle-0.12.17.tar.gz"
    sha256 "e9eaa412a60cc3d42ceb42f58d15864d9ed1b92e9d630b8130c871c5bb16107c"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/62/85/7585750fd65599e88df0fed59c74f5075d4ea2fe611deceb95dd1c2fb25b/certifi-2019.9.11.tar.gz"
    sha256 "e4f3620cfea4f83eedc95b24abd9cd56f3c4b146dd0177e83a21b4eb49e21e50"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f8/5c/f60e9d8a1e77005f664b76ff8aeaee5bc05d0a91798afd7f53fc998dbc47/Click-7.0.tar.gz"
    sha256 "5b94b49521f6456670fdb30cd82a4eca9412788a93fa6dd6df72c94d5a8ff2d7"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/76/53/e785891dce0e2f2b9f4b4ff5bc6062a53332ed28833c7afede841f46a5db/colorama-0.4.1.tar.gz"
    sha256 "05eed71e2e327246ad6b38c540c4a3117230b19679b875190486ddd2d721422d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "marshmallow" do
    url "https://files.pythonhosted.org/packages/da/f1/99a0fcf54d349f615d43addd3911f63d979775a11d94ffab0f33cd71099d/marshmallow-2.20.5.tar.gz"
    sha256 "ee20892f41b2ac51f9f1927f30696a2fb91b99fe9e12bf54624e78654612cba7"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/fa/9a/0674cb1725196568bdbca98304f2efb17368b57af1a4bb3fc772c026f474/pyelftools-0.25.tar.gz"
    sha256 "89c6da6f56280c37a5ff33468591ba9a124e17d71fe42de971818cbff46c1b24"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/cc/74/11b04703ec416717b247d789103277269d567db575d2fd88f25d9767fe3d/pyserial-3.4.tar.gz"
    sha256 "6e2d401fdee0eab996cf734e67773a0143b932772ca8b42451440cfed942c627"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/01/62/ddcf76d1d19885e8579acb1b1df26a852b03472c0e46d2b959a714c90608/requests-2.22.0.tar.gz"
    sha256 "11e007a8a2aa0323f5a921e9e6a2d7e4e67d9877e85773fba9ba6419025cbeb4"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/50/f4/23afe84747db04f1ad8d43b2436efc004bafb63a96c9a64fc6af606cf990/semantic_version-2.8.2.tar.gz"
    sha256 "71c716e99086c44d068262b86e4775aa6db7fabee0743e4e33b00fbf6f672585"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/66/d4/977fdd5186b7cdbb7c43a7aac7c5e4e0337a84cb802e154616f3cfc84563/tabulate-0.8.5.tar.gz"
    sha256 "d0097023658d4dea848d6ae73af84532d1e86617ac0925d1adf1dd903985dac3"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ff/44/29655168da441dff66de03952880c6e2d17b252836ff1aa4421fba556424/urllib3-1.25.6.tar.gz"
    sha256 "9a107b99a5393caf59c7aa3c1249c16e6879447533d0887f4336dde834c7be86"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"platformio"
    system bin/"pio"
    system bin/"piodebuggdb", "--help"
  end
end
