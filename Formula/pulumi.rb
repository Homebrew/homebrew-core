class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v2.23.2",
      revision: "5ca9f4f57a4b18e547d161078aa09ebb63d57011"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b677510d619b3f8b3e0ec641d6e2163c78e661fbf6ffce873c8c4539591d5bb3"
    sha256 cellar: :any_skip_relocation, big_sur:       "dc87fee7268530346be4020037af421abc7c63746573d183528cfe5d07150f58"
    sha256 cellar: :any_skip_relocation, catalina:      "3cc01b053a3e8cdba5efcec68ebf802472e3fe5024c41635230b0ae7e2db0bde"
    sha256 cellar: :any_skip_relocation, mojave:        "8147d31eb386443ce70dc7eb7377de35860022c39e007977a803294d5a23868e"
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
