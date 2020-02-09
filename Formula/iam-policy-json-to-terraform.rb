class IamPolicyJsonToTerraform < Formula
  desc "Convert a JSON IAM Policy into terraform"
  homepage "https://github.com/flosell/iam-policy-json-to-terraform"
  url "https://github.com/flosell/iam-policy-json-to-terraform/archive/1.3.0.tar.gz"
  sha256 "90b5be7caa232186718b5645b2d5ab65a59695854db7598462bdbe059444a051"
  head "https://github.com/flosell/iam-policy-json-to-terraform.git"

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
