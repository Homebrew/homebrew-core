class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.40.0-alpha.1662094409",
      revision: "bed60cb283c19a13b3c75cc38050118c928263e3"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d760fc76e552bc16888a94ba8cb4e73ff8e0bc1d2804bbb15f5efa218020cd4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58aaa2dd31c3b373a05a1bb12100ef163cbf8a74074f20a38efc05bf482a2b4c"
    sha256 cellar: :any_skip_relocation, monterey:       "9d6593d1c1cc82f5d371b1c912b68755c6542630c86e95d84ee6b12b3480d9ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "21822522090f074b8afec25a52a42ac9ef5ac5ffb65edfe5f9629f1036f45792"
    sha256 cellar: :any_skip_relocation, catalina:       "1af2179b2a877e52c7430f93be86c907003ae91943701acea2e9363d1cc3e514"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcd4498d4f8356806370c7ae5372227c39172ba2d7b6135ac772a53c6d397cec"
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
