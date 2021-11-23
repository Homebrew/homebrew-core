class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.18.1",
      revision: "c6cefcd3f4dc8d7603f368500b6226a07a7e9567"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76674a3135173fdf817a8b5dfb4e7fb1117f4b612c2ca3f5647a73176fcc8945"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebc35a5538f43d2e6fc7fbeb838a8a507263e483f3a9d2b9920a148d477d6ac4"
    sha256 cellar: :any_skip_relocation, monterey:       "b99623bc11f365c9ca54081727a8abc16e24945b0117136979d87e5e6e53491e"
    sha256 cellar: :any_skip_relocation, big_sur:        "46653afa23bbf72c1436eff06b40b3cd7fbb0f96a0601974c5a516b71a708ca0"
    sha256 cellar: :any_skip_relocation, catalina:       "15b31ee8f7fe2a20ac231ccf3b29f7bd2b1beb3db7830b094164e41844e1c380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "531a90603810be7ad394f1b6d339af1b5a93c4e3364ef58aac61213d8f9d9e4b"
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
