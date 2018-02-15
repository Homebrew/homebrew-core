class Dip < Formula
  include Language::Python::Virtualenv

  desc "Distribute CLIs using docker-compose"
  homepage "https://github.com/amancevice/dip"
  url "https://github.com/amancevice/dip/archive/1.3.5.tar.gz"
  sha256 "40c527a4415c6f15edb056a6f318581ed8872f7c6f9dbf6046ab017028e14d57"
  head "https://github.com/amancevice/dip.git"

  depends_on "python3"

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/06/2c/ad2baf15231a215c7be0324bdebd3175c320e60eba4cf347560d5749c5b8/cached-property-1.3.1.tar.gz"
    sha256 "6562f0be134957547421dda11640e8cadfa7c23238fc4e0821ab69efdb1095f3"
  end

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

  resource "colored" do
    url "https://files.pythonhosted.org/packages/19/be/85e6c8c1fd9b3d15d4500531ccbb164854d427690ad41c9ce9222ccabaf5/colored-1.3.5.tar.gz"
    sha256 "84fb1c1e6686d94232a14ab1abec146af0c72f756067ea684bc401ec1f4b442b"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/ee/e6/f0b3ca4d0f973751a012734c84339468d30895f60077c08cdbe215c841f7/docker-2.7.0.tar.gz"
    sha256 "144248308e8ea31c4863c6d74e1b55daf97cc190b61d0fe7b7313ab920d6a76c"
  end

  resource "docker-compose" do
    url "https://files.pythonhosted.org/packages/5d/57/9f50507280bc4269b6e8998fee7539ed2e0a98ab1bcc54d62b49cbc021ca/docker-compose-1.18.0.tar.gz"
    sha256 "2930cbfe2685018fbb75377600ab6288861d9955717b3f14212f63950351d379"
  end

  resource "docker-pycreds" do
    url "https://files.pythonhosted.org/packages/95/2e/3c99b8707a397153bc78870eb140c580628d7897276960da25d8a83c4719/docker-pycreds-0.2.1.tar.gz"
    sha256 "93833a2cf280b7d8abbe1b8121530413250c6cd4ffed2c1cf085f335262f7348"
  end

  resource "dockerpty" do
    url "https://files.pythonhosted.org/packages/8d/ee/e9ecce4c32204a6738e0a5d5883d3413794d7498fe8b06f44becc028d3ba/dockerpty-0.4.1.tar.gz"
    sha256 "69a9d69d573a0daa31bcd1c0774eeed5c15c295fe719c61aca550ed1393156ce"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "gitdb2" do
    url "https://files.pythonhosted.org/packages/84/11/22e68bd46fd545b17d0a0b200cf75c20e9e7b817726a69ad5f3070fd0d3c/gitdb2-2.0.3.tar.gz"
    sha256 "b60e29d4533e5e25bb50b7678bbc187c8f6bcff1344b4f293b2ba55c85795f09"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/e1/ec/9f2bbc86a0188bf83221212be87fa4b70dc71a9385efcc95a25e9789894e/GitPython-2.1.7.tar.gz"
    sha256 "13c7cd99c2bf277fc99accfc25148752fa90e7cc6c6d08a3f01d229dacb461d9"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/58/b9/171dbb07e18c6346090a37f03c7e74410a1a56123f847efed59af260a298/jsonschema-2.6.0.tar.gz"
    sha256 "6ff5f3180870836cae40f06fa10419f557208175f13ad7bc26caa77beb1f6e02"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"
    sha256 "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "smmap2" do
    url "https://files.pythonhosted.org/packages/48/d8/25d9b4b875ab3c2400ec7794ceda8093b51101a9d784da608bf65ab5f5f5/smmap2-2.0.3.tar.gz"
    sha256 "c7530db63f15f09f8251094b22091298e82bf6c699a6b8344aaaef3f2e1276c3"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/02/e1/2565e6b842de7945af0555167d33acfc8a615584ef7abd30d1eae00a4d80/texttable-0.9.1.tar.gz"
    sha256 "119041773ff03596b56392532f9315cb3a3116e404fd6f36e76a7dc088d95c79"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/83/91/162f2c76729633d1dc36b09746895c7766bc183bba94cb4d2ec398676060/websocket_client-0.46.0.tar.gz"
    sha256 "933f6bbf08b381f2adbca9e93d7e7958ba212b42c73acb310b18f0fbe74f3738"
  end

  def install
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources
  end

  def caveats; <<~EOS
    Use envrionmental variables:
      * DIP_HOME
      * DIP_PATH
    to customize the settings.json home and executable installation PATH
    EOS
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match "Usage", shell_output("#{bin}/dip --help")
  end
end
