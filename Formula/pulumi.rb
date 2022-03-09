class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.26.0",
      revision: "e83f6195b3090724554bef49ea34c1e25195b1fe"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c01733896747bf4f86d6e3be70dcc7d5cc1a9a855485a75b0772c8e6ee2af8f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70073b00e6a511c2bf8efd0b245b472ddc46dab6d2ef64b749d4925a87282cbf"
    sha256 cellar: :any_skip_relocation, monterey:       "20aee69ab420f5aded55542d9ad0c297ba16ed4029fa1fb4458f6647026946d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "52903f6545209ef24c24f71306e45ec33d5fa9e96574c1e1de1867b3ca3fb7dd"
    sha256 cellar: :any_skip_relocation, catalina:       "815d3e4f1749c5b9d274025887930c8ac7b2aba9247d660caf7ad22f71ba1b29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6699e239ecc5a8dc7a564efb243ea4147f397775e93bb4fbe18a21761bf4c8a"
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
