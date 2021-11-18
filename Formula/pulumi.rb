class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.18.0",
      revision: "06a19b53ed9fae99d7fbb981c14995839c19cc88"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c36254a195cce6eaa20d304d3fcc18d31b7fd3b15e94f53aa8d5457a00226cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28b5fa68e01469422f3e05d88ee41188a6b31c326b124a5928767c7f6b9b20b3"
    sha256 cellar: :any_skip_relocation, monterey:       "58409c648f0d7143e339e58404b1dbee58288d6695af451642ef113c68abff29"
    sha256 cellar: :any_skip_relocation, big_sur:        "720d7b02ea5db266511649c853849447cf50fedefe0b95fa1dc25f14a575cdf6"
    sha256 cellar: :any_skip_relocation, catalina:       "e1e2f0b0d169653d6e8d2d60d73640010574f3b2cb32dc8797d181a399b0eaee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2f862745bd59ccc98a1343170a7b62adbf536478864197d2a161ddf032747c1"
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
