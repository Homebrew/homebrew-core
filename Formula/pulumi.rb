class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v2.20.0",
      revision: "a1387c5d6caa1561ed4f6a6e86d41e7258b9c74d"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d48aa16f8c0762236301f4870a7aacd46f5c6835d9f2baef9583c5104ab05c85"
    sha256 cellar: :any_skip_relocation, big_sur:       "c168916bf1b35b0e584496ed691d535462e86c02c943f871010acf76b4e0247b"
    sha256 cellar: :any_skip_relocation, catalina:      "7478d5d6cb160d811b44b1fe577966b1f4767618a00560c489c270340b15a3cc"
    sha256 cellar: :any_skip_relocation, mojave:        "9443232b76c444c73963cbe04abf1107f9435c451f3593080b7ddf6e98e1e25e"
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
