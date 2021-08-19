class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.10.3",
      revision: "d8ebde1590088a21216329b429a83f7b39b512ef"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ff609577bcdd5cf93ca48c8996b4a702b87b31a8c5e05a697b2144e8fb0b2cc3"
    sha256 cellar: :any_skip_relocation, big_sur:       "33a9f23e686686536cc60ba8a1a4a31a45296f07c5f16d28dd18391c43524da0"
    sha256 cellar: :any_skip_relocation, catalina:      "e8629f9714758e21ff067a0a91e87bff3ce5e7f3aabcf3ba7f4b9974c3762347"
    sha256 cellar: :any_skip_relocation, mojave:        "dd88b9911124831b0bf83b8ac45b36d246867bfa20258f794852a93be7dcd10b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87fb378f1261b942bec4403aed9f9d3065333848cb66236cb368ad786f81db74"
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
