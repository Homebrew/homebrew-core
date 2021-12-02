class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.19.0",
      revision: "8ea38f633d472788fea20899fbbb183ff1284561"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e26da7f19d9f3e3c1ad14e06142305e3b99a9ab579dd04fff6e33fa63fa0f8e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "176ded8a0c3713d3069753453780cbd91f004985952bdb9661b1fa8e6332533f"
    sha256 cellar: :any_skip_relocation, monterey:       "10e1f4c0adf41a8ac423169f13382cb8f7767fb53ba681389efb22d886790c28"
    sha256 cellar: :any_skip_relocation, big_sur:        "3698873428d4d3a069aba06aaadced40fe0b27d49df075254748a475f35cf90e"
    sha256 cellar: :any_skip_relocation, catalina:       "e1bf6df914519222cd6a578a54f5fc78ffa9822c72a0b5ac8ecb89c960cf0cda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3fa7546d2f577647e97e0cd255cfbbb3830b8edc4ae260ae59e66491f410576"
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
