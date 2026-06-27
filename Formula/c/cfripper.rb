class Cfripper < Formula
  include Language::Python::Virtualenv

  desc "Library and CLI tool to analyse CloudFormation templates for security issues"
  homepage "https://cfripper.readthedocs.io"
  url "https://files.pythonhosted.org/packages/19/76/fdea07181d0988203f83dbb54be4db52f42243879372cd099cb45bbe405d/cfripper-1.20.1.tar.gz"
  sha256 "3a6e1674b3d6346cca6c87f39f8db8d7d112a3ecc6b396ccf32b8048881e1458"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e55af1033c5567bb07806ee971d3e20599278d8b61c74486a3f638a22a92e177"
    sha256 cellar: :any,                 arm64_sequoia: "8e5124b4254767b28564ecaaf8cdce3c48f125e8bb4d6d5f0cf6a7fda99bc360"
    sha256 cellar: :any,                 arm64_sonoma:  "ebb259133ed941fc7ecec10b8fd8f68bb0f11e177523318ee1f8f0036bcb5bfc"
    sha256 cellar: :any,                 sonoma:        "4f4ce5903797d72dc94c815bc70cd862384b716168db0719d821c43277c8acd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77454e686bc7d5def7bfae52d00c19a1d05b12a7ae825e5bf576de05731726aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a59cf9e91b316f9922ceb706299a88126318be2e089b40b5a4ba99ec58ee1a4"
  end

  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "pydantic"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/0a/37/78c630d1308964aa9abf44951d9c4df776546ff37251ec2434944e205c4e/boto3-1.43.6.tar.gz"
    sha256 "e6315effaf12b890b99956e6f8e2c3000a3f64e4ee91943cec3895ce9a836afb"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/79/a7/23d0f5028011455096a1eeac0ddf3cbe147b3e855e127342f8202552194d/botocore-1.43.6.tar.gz"
    sha256 "b1e395b347356860398da42e61c808cf1e34b6fa7180cf2b9d87d986e1a06ba0"
  end

  resource "cfn-flip" do
    url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
    sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pycfmodel" do
    url "https://files.pythonhosted.org/packages/99/05/467d9f6faf905a8f6ec63e432d2f63294c63a2aeaa6d0fd44b55db16d722/pycfmodel-2.1.0.tar.gz"
    sha256 "cbe0fb918cd27938ee995649bfc88ff0b4bd84299c4b2dc71d6eb500406af176"
  end

  resource "pydash" do
    url "https://files.pythonhosted.org/packages/75/c1/1c55272f49d761cec38ddb80be9817935b9c91ebd6a8988e10f532868d56/pydash-8.0.6.tar.gz"
    sha256 "b2821547e9723f69cf3a986be4db64de41730be149b2641947ecd12e1e11025a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/9b/ec/7c692cde9125b77e84b307354d4fb705f98b8ccad59a036d5957ca75bfc3/s3transfer-0.17.0.tar.gz"
    sha256 "9edeb6d1c3c2f89d6050348548834ad8289610d886e5bf7b7207728bd43ce33a"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"cfripper", shell_parameter_format: :click)
  end

  test do
    (testpath/"test.json").write <<~JSON
      {
        "AWSTemplateFormatVersion": "2010-09-09",
        "Resources": {
          "RootRole": {
            "Type": "AWS::IAM::Role",
            "Properties": {
              "AssumeRolePolicyDocument": {
                "Version": "2012-10-17",
                "Statement": [
                  {
                    "Effect": "Allow",
                    "Principal": {
                      "AWS": "arn:aws:iam::999999999:role/someuser@bla.com"
                    },
                    "Action": "sts:AssumeRole"
                  }
                ]
              },
              "Path": "/",
              "Policies": []
            }
          }
        }
      }
    JSON

    output = shell_output("#{bin}/cfripper #{testpath}/test.json --format txt 2>&1")
    assert_match "no AWS Account ID was found in the config.", output
    assert_match "Valid: True", output

    assert_match version.to_s, shell_output("#{bin}/cfripper --version")
  end
end
