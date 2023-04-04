class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.61.0",
      revision: "1ed4fad01eac03b98cc813008503ec813bae1b6a"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "352164e9965132a89b0be3d4b209702ed693c14f3ab336072600e320797a9759"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a134cfea4363fd283c2918415fa7ad88ccdf9009360679023a5bf8c44d32034f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc49ca894946011c8fee2013887a3882a3832b0b71164e8509b4ed0550769876"
    sha256 cellar: :any_skip_relocation, ventura:        "c76535bee82ca0cfe6c8db2e799736d31f99d9d79191b81e04139efe3426566b"
    sha256 cellar: :any_skip_relocation, monterey:       "84b105e9a2758589edd256ded338a913f5e1aa27f68b9c538d22ead1f2ba86b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "619524f559add9bc9a229dda813de6af7199651438a14d5313f7b77ad04fa4a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "619f731c39bc0e940a52344d6e3c01ab21bccb6cd8820c554c92ace1554eaeb0"
  end

  depends_on "go" => :build

  def install
    cd "./sdk" do
      system "go", "mod", "download"
    end
    cd "./pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}/bin/pulumi*"]

    # Install shell completions
    generate_completions_from_executable(bin/"pulumi", "gen-completion")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
