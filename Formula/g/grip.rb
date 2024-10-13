class Grip < Formula
  include Language::Python::Virtualenv

  desc "GitHub Markdown previewer"
  homepage "https://github.com/joeyespo/grip"
  url "https://files.pythonhosted.org/packages/f4/3f/e8bc3ea1f24877292fa3962ad9e0234ad4bc787dc1eb5bd08c35afd0ceca/grip-4.6.2.tar.gz"
  sha256 "3cf6dce0aa06edd663176914069af83f19dcb90f3a9c401271acfa71872f8ce3"
  license "MIT"
  revision 7

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a7d659b314c23dbf1ef69062e7424dd898d4e8f62b2bd830f7b3e1c7a11947f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3072eb3625e9e0cc477cb1f08fc1df37f210199bcec4743a12ede0b53717128a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa7d59dec6930392ec0df786fc29213ae8c12d3e5c161c2aeb6738ded4c867f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06b49139154a06b503a4f8912bba052677e35b4600ec9b933609792d72db5f5b"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2ac9876a75263035e403a3e8a56a72a70b37407614d7da52f82094cafd83012"
    sha256 cellar: :any_skip_relocation, ventura:        "9316d3d02d442eb7f0756d4be6ad700f498693ce48429c5b502b67ff466f9343"
    sha256 cellar: :any_skip_relocation, monterey:       "5485e6e4d308d326d80a65468d3d142b99cf0c73b1f1fc96ae72dd29039ae6b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b36ed3abbb4774b03ea4d565585d190a94d472ec1a5f1482f26ba8e96efb7f0"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/1e/57/a6a1721eff09598fb01f3c7cda070c1b6a0f12d63c83236edf79a440abcc/blinker-1.8.2.tar.gz"
    sha256 "8f77b09d3bf7c795e969e9486f39c2c5e9c39d4ee07424be2bc594ece9642d83"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/41/e1/d104c83026f8d35dfd2c261df7d64738341067526406b40190bc063e829a/flask-3.0.3.tar.gz"
    sha256 "ceb27b0af3823ea2737928a4d99d125a06175b8512c445cbd9a9ce200ef76842"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/22/02/4785861427848cc11e452cc62bb541006a1087cf04a1de83aedd5530b948/Markdown-3.6.tar.gz"
    sha256 "ed4f41f6daecbeeb96e576ce414c41d2d876daa9a16cb35fa8ed8c2ddfad0224"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "path-and-address" do
    url "https://files.pythonhosted.org/packages/2b/b5/749fab14d9e84257f3b0583eedb54e013422b6c240491a4ae48d9ea5e44f/path-and-address-2.0.1.zip"
    sha256 "e96363d982b3a2de8531f4cd5f086b51d0248b58527227d43cf5014d045371b7"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/02/51/2e0fc149e7a810d300422ab543f87f2bcf64d985eb6f1228c4efd6e4f8d4/werkzeug-3.0.3.tar.gz"
    sha256 "097e5bfda9f0aba8da6b8545146def481d06aa7d3266e7448e2cccf67dd8bd18"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "<strong>Homebrew</strong> is awesome",
                 pipe_output("#{bin}/grip - --export -", "**Homebrew** is awesome.")
  end
end
