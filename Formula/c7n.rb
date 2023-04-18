class C7n < Formula
  include Language::Python::Virtualenv

  desc "Rules engine for cloud security, cost optimization, and governance"
  homepage "https://github.com/cloud-custodian/cloud-custodian"
  url "https://github.com/cloud-custodian/cloud-custodian/archive/0.9.26.0.tar.gz"
  sha256 "27e0db225b396252a1e47e72c5eefc94f291d9bd76a19676d52d2eb85297572b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d187aeae9e03251aeb802ae2ec0db7832e770f9a7cee2b1205596fc848f8708d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "303c2c3b84c6801900e9cfb7c9dc8b2879fd11667e201bedc2b582419967bce3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8339dad0b7ef6d588a9fddb13bd041591c8169d3698902393f8283a6c98e2d7c"
    sha256 cellar: :any_skip_relocation, ventura:        "8dbe7d5142412549628123369f5da613a9539aa765560f9590ee247096748c6a"
    sha256 cellar: :any_skip_relocation, monterey:       "ef0de2c048700f8a2fff395d5756d3ffddba7eecba36de696a732801ad89896c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4732c3f141ec07a78b9b0a06c885dad475f5709d936d1066e4a25e9b142f793"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef401ea0f184639947b5ea0b42deb3b26d285edc3f6b4ed28af006e76d0e36d3"
  end

  depends_on "python-tabulate"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/9d/50/e5b3e9824a387920c4b92870359c9f7dbf21a6cd6d3dff5bf4fd3b50237a/argcomplete-3.0.5.tar.gz"
    sha256 "fe3ce77125f434a0dd1bffe5f4643e64126d5731ce8d173d36f62fa43d6eb6f7"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/21/31/3f468da74c7de4fcf9b25591e682856389b3400b4b62f201e65f15ea3e07/attrs-22.2.0.tar.gz"
    sha256 "c9227bfc2f01993c03f68db37d1d15c9690188323c067c641f1a35ca58185f99"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/4a/1e/d036a30baaf70b07233a8a0d664c40e583721f203fe04a73e0ce3da30674/boto3-1.26.111.tar.gz"
    sha256 "db8733f0a723c4548b6565d8665b876e93f28837d8d6bae40cc03a6e597cd6a6"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/c8/ca/0ed2d8e1b2333d41d3757e906f6bc5ab8f2d5b62cb4edce7b4c2027c16cb/botocore-1.29.111.tar.gz"
    sha256 "c3a51d80ceac0945969f94894651c4728525c7cf2df7d7838063c3516f5ee9e3"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/57/b1/b880503681ea1b64df05106fc7e3c4e3801736cf63deffc6fa7fc5404cf5/docutils-0.18.1.tar.gz"
    sha256 "679987caf361a7539d76e584cbeddc311e3aee937877c87346f31debc63e9d06"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/a6/1d/7a01bc53a248ddb14eb0dca86f089ddf848d7b9485c31d7f840f27acbcfe/importlib_metadata-5.2.0.tar.gz"
    sha256 "404d48d62bba0b7a77ff9d405efd91501bef2e67ff4ace0bed40a0cf28c3c7cd"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/bf/90/445a7dbd275c654c268f47fa9452152709134f61f09605cf776407055a89/pyrsistent-0.19.3.tar.gz"
    sha256 "1a2994773706bbb4995c31a97bc94f1418314923bd1048c6d964837040376440"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/00/27/f0ac6b846684cecce1ee93d32450c45ab607f65c2e0255f0092032d91f07/zipp-3.15.0.tar.gz"
    sha256 "112929ad649da941c23de50f356a2b5570c954b65150642bccdd66bf194d224b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # trim last decimal point version to match semver returned from version command
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/custodian version")

    (testpath/"good-policy.yml").write <<~EOF
      policies:
      - name: ec2-auto-tag-user
        resource: ec2
        mode:
          type: cloudtrail
          role: arn:aws:iam::{account_id}:role/custodian-auto-tagger
          # note {account_id} is optional. If you put that there instead of
          # your actual account number, when the policy is provisioned it
          # will automatically inherit the account_id properly
          events:
            - RunInstances
        filters:
          - tag:CreatorName: absent
        actions:
          - type: auto-tag-user
            tag: CreatorName
            principal_id_tag: CreatorId
    EOF
    output = shell_output("#{bin}/custodian validate --verbose #{testpath}/good-policy.yml 2>&1")
    assert_match "valid", output
    # has invalid "action" key instead of "actions"
    (testpath/"bad-policy.yml").write <<~EOF
      policies:
      - name: ec2-auto-tag-user
        resource: ec2
        filters:
          - tag:CreatorName: absent
        action:
          - type: auto-tag-user
            tag: CreatorName
            principal_id_tag: CreatorId
    EOF
    output = shell_output("#{bin}/custodian validate --verbose #{testpath}/bad-policy.yml 2>&1", 1)
    assert_match "invalid", output
  end
end
