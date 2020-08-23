class IamPolicyJsonToTerraform < Formula
  desc "Convert a JSON IAM Policy into terraform"
  homepage "https://github.com/flosell/iam-policy-json-to-terraform"
  url "https://github.com/flosell/iam-policy-json-to-terraform/archive/1.5.0.tar.gz"
  sha256 "9d58642d3f532c4334dc63f45e44ff9cae254360f977bca925f20033338fadcb"
  license "Apache-2.0"
  head "https://github.com/flosell/iam-policy-json-to-terraform.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d5aa3dea843226e508c13bd46c418d7d76e928d631863002054a0bd05b139a73" => :catalina
    sha256 "b7d80897886195d53da78f483318c12c5873483faaf73bf42dc91dfe1d7ddfbc" => :mojave
    sha256 "1ad4ad756d400206cc8583a53dc57e50139b45865118d13594c5cc4acef7ff75" => :high_sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOOS"] = "darwin"

    dir = buildpath/"src/github.com/flosell/iam-policy-json-to-terraform"
    dir.install buildpath.children
    cd "src/github.com/flosell/iam-policy-json-to-terraform" do
      # system "go", "build", "-o", "iam-policy-json-to-terraform", "*.go"
      system "make", "iam-policy-json-to-terraform_darwin"
      mv "iam-policy-json-to-terraform_darwin", "iam-policy-json-to-terraform"
      bin.install "iam-policy-json-to-terraform"
      prefix.install_metafiles
    end
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
