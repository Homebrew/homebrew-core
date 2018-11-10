class Awsweeper < Formula
  desc "Clear out your AWS account with this convenient tool"
  homepage "https://github.com/cloudetc"
  url "https://github.com/cloudetc/awsweeper/archive/v0.2.0.tar.gz"
  sha256 "e867ecc3df01fb799fe900bc587676460ade1752f63c9176542bb66d27a1833a"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    awsweeper_path = buildpath/"src/github.com/cloudetc/awsweeper"
    awsweeper_path.install buildpath.children

    cd awsweeper_path do
      system "go", "build"
      bin.install "awsweeper"
    end
  end

  test do
    assert_equal "err: No valid credential sources found for AWS Provider.\n\tPlease see " \
    "https://terraform.io/docs/providers/aws/index.html for more information on\n\tproviding "\
    "credentials for the AWS Provider\n", shell_output("#{bin}/awsweeper --region eu-west-1", 1)
  end
end
