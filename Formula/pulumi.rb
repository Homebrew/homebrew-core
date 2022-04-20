class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.30.0",
      revision: "f6e5aa5b98c7a8c130cd716926347f18e127cbe1"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6c6b81e130a05a033df1e60db6f5899d7ae689f8780d0d51dfbb6c6973617e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a186681a67a8d9ccbd1ac5af7e64e91a70e30657a54e35a066e3e2f72f788fd"
    sha256 cellar: :any_skip_relocation, monterey:       "eec2cb3f1fd79b7ddb8ac79968f27c13359ef5b86ff3f1c85f9e0a00b1d35925"
    sha256 cellar: :any_skip_relocation, big_sur:        "0607d6ee9ae3df0cbf0789342389d73b733dae5230267a7772d1bcfd40daf9e7"
    sha256 cellar: :any_skip_relocation, catalina:       "e0ff60af2d70125713793987ee31e0e8b6df35e37f61decd14451213c947da8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf8e410b39cef5cdbba570a7da34898ed15c150e7ea7e94c68d96b5c0279b5de"
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
