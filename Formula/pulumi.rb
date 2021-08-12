class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.9.1",
      revision: "994f60b319afdcdac3d81e940de7e875244b3cd1"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d492f34749a68f092c50de973691d0dd5461990fbce9278d375ee672e4862368"
    sha256 cellar: :any_skip_relocation, big_sur:       "0fc37baecbc09aaa1c22eae8e7d50047bc312311e9f41732087ac953080d296a"
    sha256 cellar: :any_skip_relocation, catalina:      "ee0729b882d07d471fc77749a51c5d3309d28da614b7fbbfce3983d17b122c66"
    sha256 cellar: :any_skip_relocation, mojave:        "eac9d9787afb63bfffd0ce1c446a26102fe98d015eb23bd9f5babe2e34085063"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a1781fd7edac02d37fbddd406ef4c40b980cbf0ea9d034caed69d2dfe51eb3f"
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
