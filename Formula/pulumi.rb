class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.37.1",
      revision: "8fc9bc906cebfb87604f42aa1c8dfc2ccc2ab961"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52d6d930c995a8c21b693b74ead5a44259ac9258f4be5c7de4ecd37c22f4f075"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "130f920996eabb1a545edcb18fded70a6cb6406dd95599c90fff27388eddd7d9"
    sha256 cellar: :any_skip_relocation, monterey:       "c4f8c0769b2445b59a5420d664cacd9cb31ddf184a34915f15e9dd17a95004b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccbd0186d81657ad67a1c27ced8c6d41768d77aa16b61bb91c7c03c3d79d2b9b"
    sha256 cellar: :any_skip_relocation, catalina:       "a6d0352bbf6243b582aea5f1a0644031dd387635e0d52bc738972e18ef28c7c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e81ec8b318879ca030d6d86267f5a132ca3bbca7f9fef268fc793890bc9bf911"
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
