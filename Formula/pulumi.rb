class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.35.0",
      revision: "9bd0ffc2e84a873d276359bfdd0bc72a2221584c"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc1e7807f97bdf8096fc0362a364a8875109e1b76b4d78e7d652f048ef3f2fd4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "505e5954fda4a406a7a018389394dc0fbb37356020855e59b75f5ad67fe83e7f"
    sha256 cellar: :any_skip_relocation, monterey:       "f1c45ea37eef07f7d847a94c7606b501bcc73d2df3da1916cd2f10827f8d1fcf"
    sha256 cellar: :any_skip_relocation, big_sur:        "65d00bf1ffadb781fe2fd362666cf1d677afd47f27b6e082c4ed95818634a2c6"
    sha256 cellar: :any_skip_relocation, catalina:       "f83579640fc4d6e89600d37906fd7ac821a9baaca509f6806ab689f952a07075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cc4b93721386328db940d1c71c41fbced458b404b5f8005ca0634a8e2716f8d"
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
