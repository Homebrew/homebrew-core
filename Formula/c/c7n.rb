class C7n < Formula
  include Language::Python::Virtualenv

  desc "Rules engine for cloud security, cost optimization, and governance"
  homepage "https://github.com/cloud-custodian/cloud-custodian"
  url "https://github.com/cloud-custodian/cloud-custodian/archive/refs/tags/0.9.42.0.tar.gz"
  sha256 "88ca170ffbb01fd6af9dbefe84768285258ae6471d7d9a6ef59800ea63a66961"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "bf7beb334ef4701fbcf3151fed55f87e26a30783d2860a2436ded659002c0598"
    sha256 cellar: :any,                 arm64_sonoma:  "5f28d607db86f50e09cdedc38800c3d60311b66f39350f607e26ba66c5c6b545"
    sha256 cellar: :any,                 arm64_ventura: "03afcb4435af5dfcbd42a7af3248ef9ce0be10503306526fd853561a51972e80"
    sha256 cellar: :any,                 sonoma:        "5fbbacecee3ac9be7f736937efe374656beb7bdb4eb1ba391d59fa1a0c3f9c14"
    sha256 cellar: :any,                 ventura:       "4c09b7e33a71ef49d6374e52af07f696ad40e84540feab9aaec0f5c70949deab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb90a238b4691adbe7ed8acd9a861f1e9f148dc414abb85590514b14a8049e07"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/7f/03/581b1c29d88fffaa08abbced2e628c34dd92d32f1adaed7e42fc416938b0/argcomplete-3.5.2.tar.gz"
    sha256 "23146ed7ac4403b70bd6026402468942ceba34a6732255b9edf5b7354f68a6bb"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/fc/0f/aafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fb/attrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/04/30/af5b971fc103db5425c45c36b8fcfbcc4d5818fc782350a3a6e29f47d670/boto3-1.35.60.tar.gz"
    sha256 "e573504c67c3e438fd4b0222119ed1a73b644c78eb3b6dee0b36a6c70ecf7677"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/87/46/4c10ff89b2a164863a1d5e995e6230a76fa3f636f4144b9af24ea5f92f35/botocore-1.35.60.tar.gz"
    sha256 "378f53037d817bed2c04a006b7319745e664030182211429c924647273b29bc9"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/ae/ed/aefcc8cd0ba62a0560c3c18c33925362d46c6075480bfa4df87b28e169a9/docutils-0.21.2.tar.gz"
    sha256 "3a6b18732edf182daa3cd12775bbb338cf5691468f91eeeb109deff6ebfa986f"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/cd/12/33e59336dca5be0c398a7482335911a33aa0e20776128f038019f1a95f1b/importlib_metadata-8.5.0.tar.gz"
    sha256 "71522656f0abace1d072b9e5481a48f07c138e00f079c38c8f883823f9c26bd7"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/10/db/58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352/jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/99/5b/73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6d/referencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/23/80/afdf96daf9b27d61483ef05b38f282121db0e38f5fd4e89f40f5c86c2a4f/rpds_py-0.21.0.tar.gz"
    sha256 "ed6378c9d66d0de903763e7706383d60c33829581f0adff47b6535f1802fa6db"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/a0/a8/e0a98fd7bd874914f0608ef7c90ffde17e116aefad765021de0f012690a2/s3transfer-0.10.3.tar.gz"
    sha256 "4f50ed74ab84d474ce614475e0b8d5047ff080810aac5d01ea25231cfc944b0c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/3f/50/bad581df71744867e9468ebd0bcd6505de3b275e06f202c2cb016e3ff56f/zipp-3.21.0.tar.gz"
    sha256 "2c9958f6430a2040341a52eb608ed6dd93ef4392e02ffe219417c1b28b5dd1f4"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "custodian",
                                         base_name: "custodian", shell_parameter_format: :arg)
  end

  test do
    # trim last decimal point version to match semver returned from version command
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/custodian version")

    (testpath/"good-policy.yml").write <<~YAML
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
    YAML

    output = shell_output("#{bin}/custodian validate --verbose #{testpath}/good-policy.yml 2>&1")
    assert_match "valid", output

    # has invalid "action" key instead of "actions"
    (testpath/"bad-policy.yml").write <<~YAML
      policies:
      - name: ec2-auto-tag-user
        resource: ec2
        filters:
          - tag:CreatorName: absent
        action:
          - type: auto-tag-user
            tag: CreatorName
            principal_id_tag: CreatorId
    YAML

    output = shell_output("#{bin}/custodian validate --verbose #{testpath}/bad-policy.yml 2>&1", 1)
    assert_match "invalid", output
  end
end
