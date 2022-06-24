class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.35.1",
      revision: "cb1d35d4ff58ce6e8ea8e78f31b4a1e15de3b1ba"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b48a3f7030bf22c66a2c6222f7b597c1a4516cd42a1cfb4325efcb5748806b71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "532121bbec9fc138766991371dcbd425bcde09a70d925f80e5dab915f20c10b5"
    sha256 cellar: :any_skip_relocation, monterey:       "3e7ebe156de7603307aeb6ae40317b173dc11c508163046f3708e9fb623a0dac"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bbd2021b17b1e0e8b6e3c2bef5abe87e991ff516cf09057d858baab6c705f0b"
    sha256 cellar: :any_skip_relocation, catalina:       "997176a3ed09ff7f5273e39ceb06c0af4bde30e36e1eb307f0dfbb7ae989f854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d541816274df3f80419e100812748e7619e98167bccf950ffbd11bd7651ccafc"
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
