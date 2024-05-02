class Ccm < Formula
  include Language::Python::Virtualenv

  desc "Create and destroy an Apache Cassandra cluster on localhost"
  homepage "https://github.com/riptano/ccm"
  url "https://files.pythonhosted.org/packages/f1/12/091e82033d53b3802e1ead6b16045c5ecfb03374f8586a4ae4673a914c1a/ccm-3.1.5.tar.gz"
  sha256 "f07cc0a37116d2ce1b96c0d467f792668aa25835c73beb61639fa50a1954326c"
  license "Apache-2.0"
  revision 3
  head "https://github.com/riptano/ccm.git", branch: "master"

  bottle do
    rebuild 4
    sha256 cellar: :any,                 arm64_sonoma:   "238731a2b61638873f9a94df258f553eeb4d062a9871ae2976cee5efb23c73e5"
    sha256 cellar: :any,                 arm64_ventura:  "a5ec6e8ba4a31ce97bf0c76bab35925a9ed7e70fb316e4b94d620fe42d3a0785"
    sha256 cellar: :any,                 arm64_monterey: "a87e6a11875898d4c6852d80e0dc21008dcf4f07d8d734cabc4836bcefa116e0"
    sha256 cellar: :any,                 sonoma:         "ee37033f3eedc5ea6090a4b7b945f1409d1d57e18e7ddcb4184892221612ebc8"
    sha256 cellar: :any,                 ventura:        "b28083c2a409fc2c89dd87541d249143b3b2da4297b709dc2234a530be8237fd"
    sha256 cellar: :any,                 monterey:       "29a980cae479521c3bc2efa1599b3d6ba8871624ea1ae15b1a97202e08f29b9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85cfbe69582690550af35accb458500bde601a9f35d37fb7d3a7705b11ee1e1b"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "cassandra-driver" do
    url "https://files.pythonhosted.org/packages/59/28/3e0ea7003910166525304b65a8ffa190666b483c2cc9c38ed5746a25d0fd/cassandra-driver-3.29.0.tar.gz"
    sha256 "0a34f9534356e5fd33af8cdda109d5e945b6335cb50399b267c46368c4e93c98"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "geomet" do
    url "https://files.pythonhosted.org/packages/cf/21/58251b3de99e0b5ba649ff511f7f9e8399c3059dd52a643774106e929afa/geomet-0.2.1.post1.tar.gz"
    sha256 "91d754f7c298cbfcabd3befdb69c641c27fe75e808b27aa55028605761d17e95"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c9/3d/74c56f1c9efd7353807f8f5fa22adccdba99dc72f34311c30a69627a0fad/setuptools-69.1.0.tar.gz"
    sha256 "850894c4195f09c4ed30dba56213bf7c3f21d86ed6bdaafb5df5972593bfc401"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Usage", shell_output("#{bin}/ccm", 1)
  end
end
