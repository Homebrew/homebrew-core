class Gcalcli < Formula
  include Language::Python::Virtualenv

  desc "Easily access your Google Calendar(s) from a command-line"
  homepage "https://github.com/insanum/gcalcli"
  url "https://files.pythonhosted.org/packages/68/b8/c3f3b8c73c9740eeb592e31f3f1092485ce8809fd7137d7c776a0b0d3567/gcalcli-4.5.1.tar.gz"
  sha256 "bbc8d6b9ce40d0be0535ffec3bb3384761400c7fbf1d67716e7d0e5fe9c6f2d5"
  license "MIT"
  revision 7
  head "https://github.com/insanum/gcalcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09b170252f2124a998b4f8b5bb98b51badb66870f1435fa564f602ee9708fd0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a5d144adf68d960587565f0c05ce3046e9f604994f305c9e1e50a45bee4288b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cf2c9cf335d72be93968783be7051a9c39f6c0a0771cf3dd6e4d8c22d0b56ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "98db71aca83e4abd37f052798b643ed3886437defed8b67aa5bdae9b9b275923"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2ddec20916efd005e88c9344fe83ec738c6e5e7fc675ac51ee747f7bfa9ab8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82fa0bd6fc003834f635f60edf6f51c119188b0d578e7518b3fda41d42cdd30c"
  end

  depends_on "certifi" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: ["certifi", "pydantic"]

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/38/61/0b9ae6399dd4a58d8c1b1dc5a27d6f2808023d0b5dd3104bb99f45a33ff6/argcomplete-3.6.3.tar.gz"
    sha256 "62e8ed4fd6a45864acc8235409461b72c9a28ee785a2011cc5eb78318786c89c"
  end

  resource "babel" do
    url "https://files.pythonhosted.org/packages/7d/6b/d52e42361e1aa00709585ecc30b3f9684b3ab62530771402248b1b1d6240/babel-2.17.0.tar.gz"
    sha256 "0c54cffb19f690cdcc52a3b50bcbf71e07a808d1c80d549f2459b9d2cf0afb9d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/0d/10/05572d33273292bac49c2d1785925f7bc3ff2fe50e3044cf1062c1dde32e/google_api_core-2.29.0.tar.gz"
    sha256 "84181be0f8e6b04006df75ddfe728f24489f0af57c96a529ff7cf45bc28797f7"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/a8/d7/14613c7efbab5b428b400961f5dbac46ad9e019c44e1f3fd14d67c33111c/google_api_python_client-2.188.0.tar.gz"
    sha256 "5c469db6614f071009e3e5bb8b6aeeccae3beb3647fa9c6cd97f0d551edde0b6"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/60/3c/ec64b9a275ca22fa1cd3b6e77fefcf837b0732c890aa32d2bd21313d9b33/google_auth-2.47.0.tar.gz"
    sha256 "833229070a9dfee1a353ae9877dcd2dec069a8281a4e72e72f77d4a70ff945da"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/d5/ad/c1f2b1175096a8d04cf202ad5ea6065f108d26be6fc7215876bde4a7981d/google_auth_httplib2-0.3.0.tar.gz"
    sha256 "177898a0175252480d5ed916aeea183c2df87c1f9c26705d74ae6b951c268b0b"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/90/dd/211f27c1e927e2292c2a71d5df1a2aaf261ce50ba7d50848c6ee24e20970/google_auth_oauthlib-1.2.4.tar.gz"
    sha256 "3ca93859c6cc9003c8e12b2a0868915209d7953f05a70f4880ab57d57e56ee3e"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/e5/7b/adfd75544c415c487b33061fe7ae526165241c1ea133f9a9125a56b39fd8/googleapis_common_protos-1.72.0.tar.gz"
    sha256 "e55a601c1b32b52d7a3e65f43563e2aa61bcd737998ee672ac9b951cd49319f5"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/77/df/6eb1d485a513776bbdbb1c919b72e59b5acc51c5e7ef28ad1cd444e252a3/httplib2-0.31.1.tar.gz"
    sha256 "21591655ac54953624c6ab8d587c71675e379e31e2cfe3147c83c11e9ef41f92"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/0b/5f/19930f824ffeb0ad4372da4812c50edbd1434f678c90c2733e1188edfc63/oauthlib-3.3.1.tar.gz"
    sha256 "0f0f8aa759826a193cf66c12ea1af1637f87b9b4622d46e866952bb022e538c9"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cf/86/0248f086a84f01b37aaec0fa567b397df1a119f73c16f6c7a9aac73ea309/platformdirs-4.5.1.tar.gz"
    sha256 "61d5cdcc6065745cdd94f0f878977f8de9437be93de97c1c12f853c9c0cdcbda"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/01/89/9cbe2f4bba860e149108b683bc2efec21f14d5f7ed6e25562ad86acbc373/proto_plus-1.27.0.tar.gz"
    sha256 "873af56dd0d7e91836aee871e5799e1c6f1bda86ac9a983e0bb9f0c266a568c4"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/53/b8/cda15d9d46d03d4aa3a67cb6bffe05173440ccf86a9541afaf7ac59a1b6b/protobuf-6.33.4.tar.gz"
    sha256 "dc2e61bca3b10470c1912d166fe0af67bfc20eb55971dcef8dfa48ce14f0ed91"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/fe/b6/6e630dff89739fcd427e3f72b3d905ce0acb85a45d4ec3e2678718a3487f/pyasn1-0.6.2.tar.gz"
    sha256 "9b59a2b25ba7e4f8197db7686c09fb33e658b98339fadb826e9512629017833b"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/33/c1/1d9de9aeaa1b89b0186e5fe23294ff6517fce1bc69149185577cd31016b2/pyparsing-3.3.1.tar.gz"
    sha256 "47fad0f17ac1e2cad3de3b458570fbc9b03560aa029ed5e16ee5554da9a2251c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/da/8a/22b7beea3ee0d44b1916c0c1cb0ee3af23b700b6da9f04991899d0c555d4/rsa-4.9.1.tar.gz"
    sha256 "e7bdbfdb5497da4c07dfd35530e1a902659db6ff241e39d9953cad06ebd0ae75"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/53/a3/1585216310e344e8102c22482f6060c7a6ea0322b63e026372e6dcefcfd6/truststore-0.10.4.tar.gz"
    sha256 "9d91bd436463ad5e4ee4aba766628dd6cd7010cf3e2461756b3303710eebc301"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/98/60/f174043244c5306c9988380d2cb10009f91563fc4b31293d27e17201af56/uritemplate-4.2.0.tar.gz"
    sha256 "480c2ed180878955863323eea31b0ede668795de182617fef9c6ca09e6ec9d0e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "gcalcli",
                                         shell_parameter_format: :arg)
  end

  test do
    output = shell_output("#{bin}/gcalcli refresh 2>&1", 2)
    assert_match "invalid choice: 'refresh'", output

    output = shell_output("#{bin}/gcalcli --version")
    assert_match version.to_s, output
  end
end
