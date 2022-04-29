class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.31.0",
      revision: "a77f57f584fac68c76aeaf1f5d38ecc3066a5b48"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00a2e9199975f6304d063502f8d77d378960c9c0114a1f8978be8dff0e733dbc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2972e0601cf9651ae8e68d0132c946f626bb9ae77291c5b9141bd97c20ae811"
    sha256 cellar: :any_skip_relocation, monterey:       "13aac480776d01fad4be5440545f61b8f4a3f8fa1a1212e97d5b480776d8c15e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad58a74ad2fc0d22280438b9e2e42edc1f7255f1b8711c94428e4144c5d1e57a"
    sha256 cellar: :any_skip_relocation, catalina:       "ae1b5ab34f8bd8a6dfbc8bbab47e64a22a2333e4adf2b590f3523509059a7424"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28f415cdd095b5f3fc224f0c1d2eb1a9e10b9c1f95e684a8307aac34d432b2a0"
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
