class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.58.0",
      revision: "432209840aadae81ec9f128c48e92f3ebca1b37f"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b49ed8ffaf6f24e624d30fb86e2052004a46d97b7ad6eb15a4257a5f8336cbfb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df49f791f0b66ecc6949eb59ac33bcef9fc0e11bba080b9c52fc4c2bc776b256"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5b8768e76687b4de80c168f1de0d0d8b0d5a59af288f2084d2692b9bb988b76"
    sha256 cellar: :any_skip_relocation, ventura:        "ac1198c5d7d530d3e6aaa7b97b15c99188a2e7fcb5f0fdd7e9bc0660cf92aaa6"
    sha256 cellar: :any_skip_relocation, monterey:       "df2b272a31e996ff36434394f287b3e8d8e1c9a503344525f35900fec67454ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f62346e5d42f2cd10f918b9dd610b01c0a46dce39d226b728d95db0d4cd03e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53d25620d22739b2abbc9895436c34e6cc6dbdccedd0f111c2f0f32275154b4f"
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
