class C7n < Formula
  include Language::Python::Virtualenv

  desc "Rules engine for cloud security, cost optimization, and governance"
  homepage "https://github.com/cloud-custodian/cloud-custodian"
  url "https://github.com/cloud-custodian/cloud-custodian/archive/0.9.17.0.tar.gz"
  sha256 "18df575295d350602aef7d940313fc4cf6bb653e3b6ddd9639d79eda6f10676d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfc85e4dccc1f6053a9b431e382516519453bad2445d2b4336aa7146229a6545"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23f9cde303a7e50fc8525db5f70394fcf6067df9e95264cb0a5231ac9e685403"
    sha256 cellar: :any_skip_relocation, monterey:       "3a05a0526d59bd34bffdd332c5573782d5560f298adf4e6c6f7a02e0cdfffc0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "49d8af1df4670ad20182fea13498b449f2745cf2d16f49b38e672433f6898571"
    sha256 cellar: :any_skip_relocation, catalina:       "d251cb25488f9ae98fc54410650b2c3656bb3bd288d867515393345100b04ba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3fcaa80cbe066c6ac0ca2b82bc608efc18f7cb621c9095c4e67261051ebfff4"
  end

  depends_on "libpython-tabulate"
  depends_on "python@3.10"
  depends_on "six"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/05/f8/67851ae4fe5396ba6868c5d84219b81ea6a5d53991a6853616095c30adc0/argcomplete-2.0.0.tar.gz"
    sha256 "6372ad78c89d662035101418ae253668445b391755cfe94ea52f1b9d22425b20"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/e1/a5/fb6342b4f1f53fe77a447c400767b7120b8e7a28c552802f792923ed5074/boto3-1.24.17.tar.gz"
    sha256 "bcbf31eff02bc01f9c55e2d428b4f6a27701c86b4600cbe4e9d45aa1dd61f036"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/93/48/69dfd090a5a42cb11698b9e4789dba70fd18a607cb3c742034bb3bffe3e0/botocore-1.27.17.tar.gz"
    sha256 "af9d44592b4d0d6509b355b2ec5cb14fd23eadf7c33d13b880266dede22759ac"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/4c/17/559b4d020f4b46e0287a2eddf2d8ebf76318fd3bd495f1625414b052fdc9/docutils-0.17.1.tar.gz"
    sha256 "686577d2e4c32380bb50cbb22f575ed742d58168cee37e99117a854bcd88f125"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/35/a8/f2bd0d488c2bf932b4dda0fb91cbb687c0b1132b33130d1cfad4e2b4b963/importlib_metadata-4.11.4.tar.gz"
    sha256 "5d26852efe48c0a32b0509ffbc583fda1a2266545a78d104a6f4aff3db17d700"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b5/a0/dd13abb5f371f980037d271fd09461df18c85188216008a1e3a9c3f8bd0c/jsonschema-4.6.0.tar.gz"
    sha256 "9d6397ba4a6c0bf0300736057f649e3e12ecbc07d3e81a0dacb72de4e9801957"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/42/ac/455fdc7294acc4d4154b904e80d964cc9aae75b087bbf486be04df9f2abd/pyrsistent-0.18.1.tar.gz"
    sha256 "d4d61f8b993a7255ba714df3aca52700f8125289f84f704cf80916517c46eb96"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/cc/3c/3e8c69cd493297003da83f26ccf1faea5dd7da7892a0a7c965ac3bcba7bf/zipp-3.8.0.tar.gz"
    sha256 "56bf8aadb83c24db6c4b577e13de374ccfb67da2078beba1d037c17980bf43ad"
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
    output = shell_output("custodian validate --verbose #{testpath}/good-policy.yml 2>&1")
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
    output = shell_output("custodian validate --verbose #{testpath}/bad-policy.yml 2>&1", 1)
    assert_match "invalid", output
  end
end
