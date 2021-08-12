class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.10.1",
      revision: "7b28a0a0cfa0774f61bd19837fb02fff05db3553"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "22925cc2a4f564363740e7869a1e1b16d3506f9d7d8c0a1e6b4b0b4122bd11cb"
    sha256 cellar: :any_skip_relocation, big_sur:       "b930c6d38239ddb77da842b03ccc1d8203c11e77c1a1dcd85b8117fa47b6aad7"
    sha256 cellar: :any_skip_relocation, catalina:      "a998c60aa0a4000f07a8368fc4fa477addc0e4453a855afef4a671a1c57c55a8"
    sha256 cellar: :any_skip_relocation, mojave:        "4a64a042d80ba18d9d30bd8ee7e0d9001f479285bead90f50c4d313ea1c106f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e42995835e98bca0f2422d7eb1b7668a7fe707d553ee04c2ef41f3472823634"
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
