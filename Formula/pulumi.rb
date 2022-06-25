class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.35.1",
      revision: "cb1d35d4ff58ce6e8ea8e78f31b4a1e15de3b1ba"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "746866873f0f5886f5055ad7d17b0f9a5d1d2ad01bbac919a222a22e3b869612"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e5347bf4bee1ad9ad0e09b68278cc17672f3272aecea0a46b50640dc83364d8"
    sha256 cellar: :any_skip_relocation, monterey:       "d099e9bf600163f228474c33f58dbc82b8d424354f1001fb322113139bf5536c"
    sha256 cellar: :any_skip_relocation, big_sur:        "efadf73c50421bbd6c4d04ad8dcbaf8e2c92014d6f105898a810de93f55727fd"
    sha256 cellar: :any_skip_relocation, catalina:       "bcd13ea83f05ee460e0eb2e2f84b4ebd99952f1fb06b1ccd503b0b19510af1f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27238b77be238d2c97818eafe6a16146f0bb03803a237e6ad5cdbaebd25fba5c"
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
