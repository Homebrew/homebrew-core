class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.16.0",
      revision: "b8514450b5996d5433091bdb8fc12e7eb4fcde88"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b71a9e6107a768824917e8f52928e46f7735ea560d8c4b66c01143c878c76da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60c7589230970b916a19a8cbb9cb831af421f6d6a80a998aa6ae0703115e8061"
    sha256 cellar: :any_skip_relocation, monterey:       "e71afaad70bb54ea2c869966a13706fb3ddb74ee86792ad7e7bba8b533bedd1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a43fa4a2c0d8b4e569e673ecd137e5cb63ceaf14d943528032fe7890e200a4c"
    sha256 cellar: :any_skip_relocation, catalina:       "a7dbfeb809a10ce1adf11dae332a15cea5371a703e80090aacd453f0251cd16c"
    sha256 cellar: :any_skip_relocation, mojave:         "10be44cc34a261cdbfcd2209199545e3b61615666d70e45fac6a0d0e4e138352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7b87e200081ce699a5e7fab864b57bb499c8ec56e418da7371ffaf3d61a96e5"
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
