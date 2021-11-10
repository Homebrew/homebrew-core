class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.17.1",
      revision: "ac3f0a36c2262e1d59c02421cf834e7c02ff9d70"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3373f9a0d8a4e0458066b60d7e223c83bd5396d1661834e2aba3ed625855a81d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bc7b2ded1cc0abcfdb51711966a1629942ae74621ee778738abbc7078470f0c"
    sha256 cellar: :any_skip_relocation, monterey:       "6f352e64e26535fffd45f7e071a9b278ce9464099184bbdd5537d4e4b7efb832"
    sha256 cellar: :any_skip_relocation, big_sur:        "b87f8f43124f89976ec7ef77082277981c56f0a56d3e631b99b8987e8e29d52b"
    sha256 cellar: :any_skip_relocation, catalina:       "947b35c062d64663dcaaa027bfbcff8f300d2f6853ce40909c9d40e775f9ff24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "484df864609998da3f613405af73cc100dffef0efa396ee3d45da949013d367f"
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
