class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.7.0",
      revision: "48e5882d0e557058937cdb064c5f5b41b3952029"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3c5d44eb54b048e0707194b92ce764b001f5f5ffd11cf20c23a7dd57df3ec043"
    sha256 cellar: :any_skip_relocation, big_sur:       "de971e4a58e64679f925033249c5a4dd793591a5d03cf6fb8525277c287dc418"
    sha256 cellar: :any_skip_relocation, catalina:      "af9ab4856e67c58c54a50aad77583cd52ab4fe8d73a9baa5127e7545427a4527"
    sha256 cellar: :any_skip_relocation, mojave:        "83effe95f40f9e674925bba1052a77c38b40cf872260f49f9a805828e93d07c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9905a2c5266f11d6805c31c7579278c288d22ae6492babc2b060906628898bb5"
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
