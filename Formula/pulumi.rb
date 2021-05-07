class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.2.1",
      revision: "24875d810cff410fa447775a3b8a3bde61c2637b"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4e75d122b1945453f35cfa4876f7b3848fa85b7de42b10dd7f5aed92d33c8342"
    sha256 cellar: :any_skip_relocation, big_sur:       "4422a5120765a66bf73e608b1f7a117550c8c43a0cc960920152978e69b089a1"
    sha256 cellar: :any_skip_relocation, catalina:      "31488a0495c8943199b0d0105b39f8e96152f9b9bd33c8e4606c1f815a495c35"
    sha256 cellar: :any_skip_relocation, mojave:        "476f2a072c01a8f51c407e59f14ab0201fd78fdfae99570dfc67339cb2bf7cba"
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
