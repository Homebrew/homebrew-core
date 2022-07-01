class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.35.3",
      revision: "e78abcb5b5ce42737735e571d6b82c2dded72b2f"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81d35135ccbd230b4cd11b318a1c61565ffc89b893c74a677575b771cd962471"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c59581ae4e739e06dc6d8044754c9a846634da8c7662716fa2c12e16fc17761"
    sha256 cellar: :any_skip_relocation, monterey:       "25a1892ef63ffbedd301c15e31ee0f2e96c21d6e75a27c3060959161d58d8719"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ffdd90b7d8f40891e906167746dc44f908946e44154f17d7500e3d7a60ba860"
    sha256 cellar: :any_skip_relocation, catalina:       "7702dc389ecc6978099a753d5dbfefb1696e2623cf07888f9a68dddd2311cce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "405e39107cb844d35cf66b93b9a48f9aae87bfdd19e65b2980855a166952fba5"
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
