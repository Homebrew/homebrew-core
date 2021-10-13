class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.14.0",
      revision: "a1b6b1ee6ad855ccbc1e1f582a5ff4ee0bb06697"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "868207c8ddbab10fae0a4cd17953457d11bbfc6955ab27cc0f3d57bef706c824"
    sha256 cellar: :any_skip_relocation, big_sur:       "2b9c6b96309e292918ed879fff9f588b108cb92fd10e04357fce920261f2c01d"
    sha256 cellar: :any_skip_relocation, catalina:      "404b5bda910f16377ad3da4bd11fbebdc957ef3de85f478f6c9499cfe6a4a07a"
    sha256 cellar: :any_skip_relocation, mojave:        "aad8905094b1874e075418795349980cb7990fff1a8d18caa5c76685c0a5cfe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e40388d33e57dbd6cfaf17cda77538c61033399799180093ee6d527fde2b63c6"
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
