class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.24.1",
      revision: "0d977721778805179bc502dddbdfe848f8477d9f"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3df45fa1f61e370837fe9ce65da8dd2485b6e966d7b568c490a10641e34763a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d82e97309eb57e505d8ed3dd27959e62fae6d163e6915245c83af008a343e830"
    sha256 cellar: :any_skip_relocation, monterey:       "4b1b4f102e217a723430f410b53fecd9fad9125a82c9203f947bc4f612aa4c4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "59faa35439a6f2d1727e7dbc9ece8f6aa119c452746e7b534dce8f085aa5b4ba"
    sha256 cellar: :any_skip_relocation, catalina:       "7ad9cc70fc8b1e91e458ea3aa3fcbe56c2faba61708aaae58408ae4d8c69380e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ae9e043a4516b5056299da58960065cbdacc39f6ee4299b966fbbee770cef61"
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
