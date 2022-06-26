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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0afbb4b4623fd1d164d742e64247fce9912ee49b36156ee654e6ccca9d8b8d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3327e612ae47705224d8aaa05b516b5dea4c35dd0b411cde6253f66def171b58"
    sha256 cellar: :any_skip_relocation, monterey:       "fa06c77a9703e116d09988d230fb256d8123cdad6251d8a34e750e13981dbdae"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf6b0a4df32b09df6f4809b54b0dcf81a2dcc63c95828dc2178c75a5ac98ecbe"
    sha256 cellar: :any_skip_relocation, catalina:       "ba15093446fbe0f1beb000f890f26adff53901dc7d6c9261b8e3dc31a5f00cfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f1e9482baf6aa02be97dd299448a47420d6ba56986e04292312c58c01830978"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "cassandra-driver" do
    url "https://files.pythonhosted.org/packages/19/bd/b522b200e8a7cc5ace859e9667308a3a302a23d6df09ae087ca2dfbf60c2/cassandra-driver-3.22.0.tar.gz"
    sha256 "df825ee4ebb7f7fa33ab028d673530184fe0ee41ea66b2f9ddd478db56145a31"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Usage", shell_output("#{bin}/ccm", 1)
  end
end
