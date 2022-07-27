class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.37.0",
      revision: "07f76d26194f4eedb2679d832f16fc70f4d7a3e8"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ce82015b4d6de88a966b7c4ff3f6a68b670ce2763aef4ea210475e88a63689a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54b093ea6938685c431d2b56995e0e8b4641b11b3c38726712f11b638bab81d5"
    sha256 cellar: :any_skip_relocation, monterey:       "4ebe88957f73ec03b568ac6f41fc56615c57e79cfaab5f7d6fc53eca6e9409d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1aadca71c249569de11986717133ef9eea4a80595b4382359cdd6041775c4e4"
    sha256 cellar: :any_skip_relocation, catalina:       "6521ae61a8306d5dc346dd8140b97c314c56afb9c4379e2d1fe739bda5d74952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b979671340568082044958af72412fa5ba500ec58847632ea6eb180a823fa97e"
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
