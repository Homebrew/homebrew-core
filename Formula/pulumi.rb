class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v2.24.0",
      revision: "80a43e9bec0564a65fd8165bff111656432e2099"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3a1add839ffdc2d142bf4021ff4ce9ccb2b05e52e4426c8c74cf19a06cf5a855"
    sha256 cellar: :any_skip_relocation, big_sur:       "50002ec7da6498d176d9ce189426e679a09e40384f1669ab8e399e8cdc1869d6"
    sha256 cellar: :any_skip_relocation, catalina:      "68d3b08aab8d55c5f8e0f590546a6958eca3ef08394380ded3ab4c78a98d5755"
    sha256 cellar: :any_skip_relocation, mojave:        "daa89248dc6686970267ff54ea4c7b3251c990f603f91b637f2b8835fcd42f1c"
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
