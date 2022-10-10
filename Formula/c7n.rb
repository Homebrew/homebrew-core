class C7n < Formula
  include Language::Python::Virtualenv

  desc "Rules engine for cloud security, cost optimization, and governance"
  homepage "https://github.com/cloud-custodian/cloud-custodian"
  url "https://github.com/cloud-custodian/cloud-custodian/archive/0.9.20.0.tar.gz"
  sha256 "d9cd353ce1ae4158503aaf8b5443299fbfd65672d861b54f98208c025df4eff2"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c60e9686aad975d38bcc320687c4b10a7718dc0e3409ef622ae4b000ee72ffc1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d912fadfe0bb6159d5d1e8742d23ecc08f6b516cb7c8d31c455340575959bb3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b5c5cffe06b72344f5f7dd288587b5cedc8650b66850a1661fccbeac119fa0f"
    sha256 cellar: :any_skip_relocation, ventura:        "1cbe0f692df3a64525374ed179561c9392d24c86f4cb7dde82df5f8f4bd9fb32"
    sha256 cellar: :any_skip_relocation, monterey:       "ffe4f808cb194fccc39553c029251c000da39393bf8328d8bfb4bb3cd2681de9"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc6a84caa02f2cfe0323f740e0ea3dea8b4a83d98626e7c6efd92fc318cad71a"
    sha256 cellar: :any_skip_relocation, catalina:       "07d0bb044f14970d8836365e8d5ccffd5ec8eb35c41b1bae30ef9f40593fdd90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8fd9426a4c7c0671210d99e7d43cf5333885b9638385aff2da479704d3fa942"
  end

  depends_on "jsonschema"
  depends_on "python-tabulate"
  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "six"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/05/f8/67851ae4fe5396ba6868c5d84219b81ea6a5d53991a6853616095c30adc0/argcomplete-2.0.0.tar.gz"
    sha256 "6372ad78c89d662035101418ae253668445b391755cfe94ea52f1b9d22425b20"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/80/ab/956f77cbb907b486d100d5644064f02c1ddf21cda64435a9ffe0dd19ab82/boto3-1.25.4.tar.gz"
    sha256 "03e5055d64a596f7a95ed0ca9fda1b67b7aed00d428e4ccef97f2f82b72ec875"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/92/d4/5a0127c24ebc39289bb5cdd4b928a24c2b8d9377778f69887984e613ca26/botocore-1.28.4.tar.gz"
    sha256 "ade670506c9e837f61d590873a11c5d06ab9a8492b8d5b853d6c4059ecddc03d"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/4c/17/559b4d020f4b46e0287a2eddf2d8ebf76318fd3bd495f1625414b052fdc9/docutils-0.17.1.tar.gz"
    sha256 "686577d2e4c32380bb50cbb22f575ed742d58168cee37e99117a854bcd88f125"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/7e/ec/97f2ce958b62961fddd7258e0ceede844953606ad09b672fa03b86c453d3/importlib_metadata-5.0.0.tar.gz"
    sha256 "da31db32b304314d044d3c12c79bd59e307889b287ad12ff387b3500835fc2ab"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
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
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/8d/d7/1bd1e0a5bc95a27a6f5c4ee8066ddfc5b69a9ec8d39ab11a41a804ec8f0d/zipp-3.10.0.tar.gz"
    sha256 "7a7262fd930bd3e36c50b9a64897aec3fafff3dfdeec9623ae22b40e93f99bb8"
  end

  # patch version, remove in next release
  patch do
    url "https://github.com/cloud-custodian/cloud-custodian/commit/690da026954f8e6c16df3fc95f3580b8fca0688d.patch?full_index=1"
    sha256 "da4f704fa8ae63a51db0d42fcb2af0dc6ccc891d9fcf902abc97ed9a18ce8a8d"
  end

  def install
    virtualenv_install_with_resources

    # we depend on jsonschema, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.10")
    jsonschema = Formula["jsonschema"].opt_libexec
    (libexec/site_packages/"homebrew-jsonschema.pth").write jsonschema/site_packages
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
