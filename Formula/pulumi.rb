class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.42.0",
      revision: "92c5a37490758b5b6c2352f4fe7af95a80e88878"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d88800bbbd82eb15f91eb5a03d4de9aadd422181e6377c80130e515c549d6e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd2f24afb25ee85d6586e979850506c04b3da7aeba96b490e137b967c6060775"
    sha256 cellar: :any_skip_relocation, monterey:       "b4a00d9b8c7d661e899761ef18604b60139910fee69d71c304ce6c646b025290"
    sha256 cellar: :any_skip_relocation, big_sur:        "69fbc005051b984179df7832443cd0298eec3d0a82fb2f0dbf9f6458bb252f19"
    sha256 cellar: :any_skip_relocation, catalina:       "f933da99f7139456be6607368c69b5d3faa9e8234bfc3329e360d2eaf9c5e6a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2c58471055fbe96a7b722e29649f046a7d63132f67af31583f56beced7a774e"
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
