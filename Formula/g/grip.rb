class Grip < Formula
  include Language::Python::Virtualenv

  desc "GitHub Markdown previewer"
  homepage "https://github.com/joeyespo/grip"
  url "https://files.pythonhosted.org/packages/f4/3f/e8bc3ea1f24877292fa3962ad9e0234ad4bc787dc1eb5bd08c35afd0ceca/grip-4.6.2.tar.gz"
  sha256 "3cf6dce0aa06edd663176914069af83f19dcb90f3a9c401271acfa71872f8ce3"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eeff898f9d6cb2ab166c2c3c7cec9f0da4fbc29da05a9e163f853abc4ed65dd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3861a5623cb92b8988650642a182a3d2ba1d7e5e2797d06870530e4405ebd7f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fc2710669fa5cfea938bbdfa23e6051747c9b3716abb92508cf38242dd37547"
    sha256 cellar: :any_skip_relocation, sonoma:         "f10a6821ab39c1a5ca0e14f770f3c0c86a4a55688cf634e2df0552bf6ce01c7b"
    sha256 cellar: :any_skip_relocation, ventura:        "96138a8d63e755cbf34f05957cc29c2a71e1c941fcd584d3f9b56b0d9386ff47"
    sha256 cellar: :any_skip_relocation, monterey:       "1b33c1f583f578ee9f2d85ae87772ac6186dae47fdb88a48894cbb724aee6924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49ba025300b693aec39ccc2433c9703b29b3392e87001b9765f51d09e4f38250"
  end

  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-markdown"
  depends_on "python-markupsafe"
  depends_on "python@3.12"

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/ea/96/ed1420a974540da7419094f2553bc198c454cee5f72576e7c7629dd12d6e/blinker-1.6.3.tar.gz"
    sha256 "152090d27c1c5c722ee7e48504b02d76502811ce02e1523553b4cf8c8b3d3a8d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
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
    url "https://files.pythonhosted.org/packages/d8/09/c1a7354d3925a3c6c8cfdebf4245bae67d633ffda1ba415add06ffc839c5/flask-3.0.0.tar.gz"
    sha256 "cfadcdb638b609361d29ec22360d6070a77d7463dcb3ab08d2c2f2f168845f58"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/7f/a1/d3fb83e7a61fa0c0d3d08ad0a94ddbeff3731c05212617dff3a94e097f08/itsdangerous-2.1.2.tar.gz"
    sha256 "5dbbc68b317e5e42f327f9021763545dc3fc3bfe22e6deb96aaf1fc38874156a"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "path-and-address" do
    url "https://files.pythonhosted.org/packages/2b/b5/749fab14d9e84257f3b0583eedb54e013422b6c240491a4ae48d9ea5e44f/path-and-address-2.0.1.zip"
    sha256 "e96363d982b3a2de8531f4cd5f086b51d0248b58527227d43cf5014d045371b7"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/8c/47/75c7099c78dc207486e30cdb2b16059ca6d5c6cdcf9290f4621368bd06e4/werkzeug-3.0.0.tar.gz"
    sha256 "3ffff4dcc32db52ef3cc94dff3000a3c2846890f3a5a51800a27b909c5e770f0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "<strong>Homebrew</strong> is awesome",
                 pipe_output("#{bin}/grip - --export -", "**Homebrew** is awesome.")
  end
end
