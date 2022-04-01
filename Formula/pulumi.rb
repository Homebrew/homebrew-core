class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.28.0",
      revision: "9f89feb16dfd437025a853c92e60854d638ef405"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bda0042ebfb42b322ffb0f92a4501f5efa2fd08d128108e711d5e7a5f7e157c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0e655df18a9bd200cfcba9cb97ac88ba05d4e07d21843a5248a92c07c211813"
    sha256 cellar: :any_skip_relocation, monterey:       "ec98630e0c48e0d1fedceedf66ad249fbd220519a3ece40fb7e2947c3ccaace7"
    sha256 cellar: :any_skip_relocation, big_sur:        "281f5e52a65d0b95ff7fc58a48c11add1c776ee1c24b24bec95d8cb7d49a6e44"
    sha256 cellar: :any_skip_relocation, catalina:       "8f676ddc38cfdd3d658901b1f01ccdbd66957c56f2cb1f0b23a36730fb704468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d4fd31b4b7742aa05bd69c504e2811a8216b9b42fda545845e9090614f05641"
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
    (bash_completion/"pulumi.bash").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "bash")
    (zsh_completion/"_pulumi").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "zsh")
    (fish_completion/"pulumi.fish").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "fish")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
