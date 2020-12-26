class IamPolicyJsonToTerraform < Formula
  desc "Convert a JSON IAM Policy into terraform"
  homepage "https://github.com/flosell/iam-policy-json-to-terraform"
  url "https://github.com/flosell/iam-policy-json-to-terraform/archive/1.6.0.tar.gz"
  sha256 "714b8aead9bf5a88989a62eb520163565c890f37ee13783a3ae549bb0b8cdead"
  license "Apache-2.0"
  revision 1
  head "https://github.com/flosell/iam-policy-json-to-terraform.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d4babe3f392c4cfea650953d5cc1450af0ae2f7aff84e1eeacb3af1add8f1c6" => :big_sur
    sha256 "b2a35b7bb87617c6cb800a1ccb845b6df15f3458dc9d9728ce757b80acecc823" => :catalina
    sha256 "01baa53333aa1aeeafc231c6fb985a21cc98bdee8a3b4812700036f3aa81401e" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    # test version
    assert_match version.to_s, shell_output("#{bin}/iam-policy-json-to-terraform -version")

    # test functionality
    test_input = '{"Statement":[{"Effect":"Allow","Action":["ec2:Describe*"],"Resource":"*"}]}'
    output = shell_output("echo '#{test_input}' | #{bin}/iam-policy-json-to-terraform")
    assert_match "ec2:Describe*", output
  end
end
