class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.0.0",
      revision: "c27e58bf2dbc899a178db2794d19e37f7eb209ba"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "98e5d5dbfc4488a49599609a4398ac1507692cb66d8de49060c1ab63e4371703"
    sha256 cellar: :any_skip_relocation, big_sur:       "4d72e8ce97c6a090995d4750b7cc6eb5717b51124b8b8da8b7b503e519efbd3d"
    sha256 cellar: :any_skip_relocation, catalina:      "d6ea0d7d2843d5888c2292199dec4a21872b107fac9f2b1be7fbfb7bf1d7c298"
    sha256 cellar: :any_skip_relocation, mojave:        "e4fa597303c1c04fb1576be0374924e651d547c8d4f73b677dc3cad501a72555"
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
