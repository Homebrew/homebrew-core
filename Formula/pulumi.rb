class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.1.0",
      revision: "5279b1dfcf50c6224143c71ab7228d7f12bfa736"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0a397f231ce41c4c0699392b1204ce4d2f8fd965bd8221f34bce5487ee33f733"
    sha256 cellar: :any_skip_relocation, big_sur:       "54d2d2d1823f55ae4951465619b11716a6177ee7d1c10a29751f366379556be4"
    sha256 cellar: :any_skip_relocation, catalina:      "6221967374e18fda27015fef6888f7757089334a7159473d1c7b021c66dcbe0e"
    sha256 cellar: :any_skip_relocation, mojave:        "2f9189839fc282ce678b19360ffa12651974ec60e35c14bc4b8c127f3dd1f9f9"
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
