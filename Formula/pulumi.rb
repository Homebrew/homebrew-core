class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.2.1",
      revision: "24875d810cff410fa447775a3b8a3bde61c2637b"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1054d7f2f6d59adb0d9af6c7ca66ea538bac1c492694f1a7194fd9b1405c2a2f"
    sha256 cellar: :any_skip_relocation, big_sur:       "6cc36d91b23f4f03a46c5aed2aa916885cb77e0dd01ebe768b38b2c321ac195d"
    sha256 cellar: :any_skip_relocation, catalina:      "7b751841c9cac1af45b8e2a9b79b62f4229f8b388738d1ad6b177448ac220e86"
    sha256 cellar: :any_skip_relocation, mojave:        "8a0e1878e9e7c0ae8786357bfcb61635e08cdc2687d54d42912b96f2fe6ad0c1"
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
