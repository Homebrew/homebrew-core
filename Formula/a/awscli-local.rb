class AwscliLocal < Formula
  include Language::Python::Virtualenv

  desc "Thin wrapper around the `aws` command-line interface for use with LocalStack"
  homepage "https://www.localstack.cloud/"
  url "https://files.pythonhosted.org/packages/25/f9/023c80ea27d67b0930f116597fd55a93f84de9b05d18b38c7d2d5d75c1c9/awscli-local-0.22.0.tar.gz"
  sha256 "3807cf2ee4bbdd4df4dfc8bef027f25bde523dcaf8119720f677ed95ebba66a4"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5809a256a92eec1365a7c9f071656a6893295fccf3160a00b29b284bd58b27b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5809a256a92eec1365a7c9f071656a6893295fccf3160a00b29b284bd58b27b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5809a256a92eec1365a7c9f071656a6893295fccf3160a00b29b284bd58b27b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c1b34601976db26914738467119a50373a1d81f13eb915c4ec9364b95223ef2"
    sha256 cellar: :any_skip_relocation, ventura:       "7c1b34601976db26914738467119a50373a1d81f13eb915c4ec9364b95223ef2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5809a256a92eec1365a7c9f071656a6893295fccf3160a00b29b284bd58b27b"
  end

  depends_on "awscli" => :test # awscli-local can work with any version of awscli
  depends_on "localstack"
  depends_on "python@3.13"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/b8/29/10988ceaa300ddc628cb899875d85d9998e3da4803226398e002d95b2741/boto3-1.35.39.tar.gz"
    sha256 "670f811c65e3c5fe4ed8c8d69be0b44b1d649e992c0fc16de43816d1188f88f1"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/f7/28/d83dbd69d7015892b53ada4fded79a5bc1b7d77259361eb8302f88c2da81/botocore-1.35.39.tar.gz"
    sha256 "cb7f851933b5ccc2fba4f0a8b846252410aa0efac5bfbe93b82d10801f5f8e90"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "localstack-client" do
    url "https://files.pythonhosted.org/packages/c4/40/6858a5fe70654ef4878188e0c330c8a22ce4dfc457e09231cb82228de075/localstack_client-2.7.tar.gz"
    sha256 "14993119901a4bcbef7c32d899b24f4a58a875a6765693edf1064d66b8a68408"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/a0/a8/e0a98fd7bd874914f0608ef7c90ffde17e116aefad765021de0f012690a2/s3transfer-0.10.3.tar.gz"
    sha256 "4f50ed74ab84d474ce614475e0b8d5047ff080810aac5d01ea25231cfc944b0c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/awslocal kinesis list-streams 2>&1", 255)
    assert_match "Could not connect to the endpoint URL", output
  end
end
