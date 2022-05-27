class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.33.2",
      revision: "ea9e28c93e5331516733155b708f2c0ba93e721e"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ce1918c12d5a48e6adf30b4e1ef922936e40412a5b74b27a7e1ae668d58e3a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6cfae0a3d0ec87cf98122f7f5b1c58b3da5556b3df0966741dc46e4bd2ad50f3"
    sha256 cellar: :any_skip_relocation, monterey:       "2894566a84b7fa7907b720e9d350fc3e24926a709dee7d80138c11d8e8b9064e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a263796fa2fd0545696be54462e41a9bbe13cc292942694535faaef30a97c40e"
    sha256 cellar: :any_skip_relocation, catalina:       "2f8fbe70e9310224eeaac6825203d8bc2cb359605856b8c0d91daa5b51ef1ca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f150446ef8ccd1c3d67949eca0a76512c236dd655a78be7672341e83a6ac9c9"
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
