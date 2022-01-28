class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.23.2",
      revision: "1bad3b9f9e9a83dee15d7527bf93557d5d3e18be"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27bccd832fe328e77fccad931b97c6cda9e8fea9d4d4075ebdccbc11ef57ad3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d3e43e50ab4b3c1bae3648e3d80494d4e25a219d1cc4ff1a5b804f521212d27"
    sha256 cellar: :any_skip_relocation, monterey:       "6164a98a9ee105c80e637d4bce2a0ef691b478b5e96077a6052ba1ff3578fcb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "3375018e22fbf690568ed5688a11657bbd636476435134a6c834c9aa9a46374a"
    sha256 cellar: :any_skip_relocation, catalina:       "472d308763ef1a04a46bd7ee3b120a620ce27ffce334be5194960456336048a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5f12bbafa48276f215286d5602580bb59d2e0d2d7b8a073ace857e465b14110"
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
