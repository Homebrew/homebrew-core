class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.21.1",
      revision: "c89abc9bd628751d2b1afd2c0a4cdbcf759ae221"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a759710e30eccaf1e31f03dbd0dc1b6b960c3af8e3784cf88ba8851d8a8cc11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "755fa55be41b860e1ad33c600282d163cc784d8e44a3ac3df9114e77289cdab8"
    sha256 cellar: :any_skip_relocation, monterey:       "4b4b5ce413c91cf7cba45d781ecc03e324994dd0ea3186e621d5d9eb7763155a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a35dc517497adad235ee3d8005c3e774a24ae599759de06f69f775c075580b81"
    sha256 cellar: :any_skip_relocation, catalina:       "d389b7efd12c4729b5fd3ef22a8e49ba23f9a7feea0b3803831a615dd3bf1444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b9f2155ed8dde137c414b0211e2fda0c3be6cd190ee5b927ef61874fe76b60e"
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
