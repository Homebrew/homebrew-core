class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.36.0",
      revision: "b2858023444870f24814b9b8535d2cf7af65f888"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0b68d9a9bc5c697525a0d4d2b2a96e75040daf5542446d557dedc3362eb997c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f3791627252891c3038aab97843b775989cbef3ab4dbd7b7f5edc4eef68e6bb"
    sha256 cellar: :any_skip_relocation, monterey:       "c3a7c6bc0c391b44ae86454188cc8d0931a9f55228572c72fc3ad873877d87d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b3fe8c030521ebcd535af41b99acd6c988d53eb60086b903526a9f7969fcccc"
    sha256 cellar: :any_skip_relocation, catalina:       "6da51c3aea0d119f05408b10e957bcdbcf580ea5e8ab89c03491e92e3dde437e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8033d630e52c8e0a2052658cf82ae2a74493bd848db7147bad935c58a1216e0b"
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
