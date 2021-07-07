class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.6.1",
      revision: "24c59add99d0f1e2917dbf6edb1b09a553045a0d"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "30ec2b7ce377eb88eecad760ec736cf06f96c6d2f30054026bbc99f11bb395ef"
    sha256 cellar: :any_skip_relocation, big_sur:       "8a693cffeaf1cf394655646983f0f3522cc0e63894f28def6cb9e8dbd2cf2fbb"
    sha256 cellar: :any_skip_relocation, catalina:      "55f91a0597efc99b274e97b8ea512474c13247428abd2a0e4357d0db966ecca5"
    sha256 cellar: :any_skip_relocation, mojave:        "53594759bc1ab698fec0c97c8812f309006e733e63f1664c57f9245b2ca65181"
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
