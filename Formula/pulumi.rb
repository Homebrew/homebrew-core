class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.13.0",
      revision: "0bcf475573f96f09d4fa8375fef1d935f439f82f"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e59982b7cdb0a74637fe6381bed2446f30f435c1b500874b6ee459289155f1c1"
    sha256 cellar: :any_skip_relocation, big_sur:       "32c6c7229232d66d6ab69a5c419ecefb8f1cbf7868e3d14b2dd84af978a834e3"
    sha256 cellar: :any_skip_relocation, catalina:      "4d1bfcb1e3eec00fa85f23fdd2fc17bb400f669c9fb78554368f79838587cc42"
    sha256 cellar: :any_skip_relocation, mojave:        "229c3fc4b7e7b4eefe6046ebfc66ff125cff7d9f15d8bc46f7541e58acb77ba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3026e4cae9f2f337ef72b89282c2a9142adf971f0536ae645a835f219f69f67e"
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
