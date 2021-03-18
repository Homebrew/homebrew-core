class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v2.23.1",
      revision: "92544b746a82bde6aa573bf0f61e6e10762ed492"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3c4391cd8b1284842b957253ac1191ce434a7a9eaa706aefd70762026c6d24ba"
    sha256 cellar: :any_skip_relocation, big_sur:       "fd8ce4903e5bdac890efd27424112c9c522d1b0f551c0c9feb22abbbc8e476b5"
    sha256 cellar: :any_skip_relocation, catalina:      "b0256f9ba6d914cccb479886a3c6fc12c843adc566e0b77158c63e2f4bdf3fe2"
    sha256 cellar: :any_skip_relocation, mojave:        "fd184d20e69f9f52b2cc01cc9d20179abad98dad80ca3d9c40c5d12bca55ccdf"
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
