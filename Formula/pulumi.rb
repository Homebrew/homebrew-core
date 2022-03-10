class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.26.1",
      revision: "5f269f66a4e50a59f4d9e66eb4b70c01dd066a58"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "084723181581d5f1c5d18846501ed4e11d5d71a62efc18f0b81d0ad3e576e33f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a731bab5459c9b77eeaa1ae1bc96bf56bdfe0154684caecab00e991565fae4ca"
    sha256 cellar: :any_skip_relocation, monterey:       "88bb1deb48d36b9347468332a5fe16dabd9582e377c8ff62f3d28c607730c20c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8170b2f4242f63ac0bba6f3d0e578ff1ea26a400d30edb1fe1ef5ee0a4b0a1e"
    sha256 cellar: :any_skip_relocation, catalina:       "dff5c0f2501cf2dd0670b1c2b51adcc69351db8705ea197e53e723a7c7dc9fb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b93b3ca7078ba8560bc43cf72bc90c3740d9d6e6834773407fc963eb9f98039f"
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
