class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v2.21.1",
      revision: "69915c89ae4726da6cbe9f82483aa86c6c4bf01c"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "00635e086404ad5bbff29eb613f450029a76ec82d99810122a5188e8543a4e68"
    sha256 cellar: :any_skip_relocation, big_sur:       "7829442e027c770893390678e88782044d6f430401b41cbde4947baf8c77c4d7"
    sha256 cellar: :any_skip_relocation, catalina:      "6be789063f378238716c86d0b3f4727d3f09eecffab01ccd8cac23c4aea3e1d5"
    sha256 cellar: :any_skip_relocation, mojave:        "e6582d50687de99b44a73561428b5b92793592a2b272e4706494e6f65ad89ab7"
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
