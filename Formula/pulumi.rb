class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v2.25.1",
      revision: "c26d89f734c1e9e5f8d626b67106f04e69bf56f9"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dbd355706d20e7f9f7fcc13d787df434dc6e614d4c12214d899d5ac42f714748"
    sha256 cellar: :any_skip_relocation, big_sur:       "a9ce5199a886f3b8bec073744c614a5a825f2e11188890ad73a090f26a5df023"
    sha256 cellar: :any_skip_relocation, catalina:      "befd8e0ed192af9d5ac5323a46fd0f1924ed5c3d42e29ecab8e80adcb1397c17"
    sha256 cellar: :any_skip_relocation, mojave:        "99d8f1818637d29fb689f83cfd2a2c54cd430813b26a3bac50ed6a36f105aa61"
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
