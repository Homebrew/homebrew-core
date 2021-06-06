class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.4.0",
      revision: "f48e108e57ac69ad531a77407bd2f73f8b2a6c4b"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "baa57777e7c394023e9cf4d2777247d7c9a9348b1adc53355c42c2c07ae77c85"
    sha256 cellar: :any_skip_relocation, big_sur:       "798ed5c9cdbaa9ef9f93478a26b4a324a6cd62c7986214c2bbbfa8d0977a08fe"
    sha256 cellar: :any_skip_relocation, catalina:      "39aeafac834fb3406642e741370210a7f9c0ffe027a792499dae140e5dcbd621"
    sha256 cellar: :any_skip_relocation, mojave:        "70c4d6467008130558a082cae56e2a9a05a31429ac787dd4fb67516d96965e38"
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
