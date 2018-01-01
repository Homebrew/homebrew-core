class GandiCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to Gandi.net products using the public API"
  homepage "http://cli.gandi.net"
  url "https://files.pythonhosted.org/packages/f1/f7/e90542fae4fcb8d921946fd55bb88e49314999b22ed2fa4e56a8cf23a434/gandi.cli-1.0.tar.gz"
  sha256 "e2534fae2136dc03f85e0d906e6c61ce2c76c38e70b33783aeb54feabc3ecf2e"

  bottle do
    cellar :any_skip_relocation
    sha256 "e10419a340f36c6dc7c084bcc2a11e6842518e269d6d1556e24371c608d42797" => :high_sierra
    sha256 "e4c50c0808a2612f4f0e8760c67bc8881e0e6298e54e97209c146e18f5c7f37e" => :sierra
    sha256 "b60eddd8819423f9baf6f4a3b4ee1df5c8996bd35094170384145a5eefa15cff" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/23/3f/8be01c50ed24a4bd6b8da799839066ce0288f66f5e11f0367323467f0cbc/certifi-2017.11.5.tar.gz"
    sha256 "5ec74291ca1136b40f0379e1128ff80e866597e4e2c1e755739a913bbc3613c0"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "IPy" do
    url "https://files.pythonhosted.org/packages/88/28/79162bfc351a3f1ab44d663ab3f03fb495806fdb592170990a1568ffbf63/IPy-0.83.tar.gz"
    sha256 "61da5a532b159b387176f6eabf11946e7458b6df8fb8b91ff1d345ca7a6edab8"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"
    sha256 "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/gandi", "--version"
  end
end
