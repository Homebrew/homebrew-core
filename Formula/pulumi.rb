class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.37.2",
      revision: "0ba7aaf8c789d787267e75ce8c938d0de067c311"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "177cf69db81db8e980af77ff44e3502592c0227019c912e8b46a216c009faba0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6e91f91408595c8c046234aa6aefc5ccedacb17446296e7e6832304a3af4252"
    sha256 cellar: :any_skip_relocation, monterey:       "c9a956a3e39c33d820a7cebb85ad76399cd2093e5185534b5595b366148457a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "0149b26603a64e16e2c4701246c56d39e731f3e50c420dfb59dae6438af7855f"
    sha256 cellar: :any_skip_relocation, catalina:       "3a55f815dbe95e15efab95d519949f7e673e995a5de6a99e44a2055805f28af2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b52c21dabf30229202c33366657568cf5d80d5f031aac57b8b7b930177c61dcd"
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
