class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.22.1",
      revision: "fe53f424dfb6748f70c8b8cf7141df9195b12990"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd280fc681d1310eef59577acc3e28e2dcf1a5f5a6f868d757a782796c3feacf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b634f9bb8ba86e7372ff2b55b72e92bf047e2ed8e049a7431bb6d247376419a8"
    sha256 cellar: :any_skip_relocation, monterey:       "2e2ac1ae485924da9719ddd9edba72f9dd4d433005245deb11903f1357f8c813"
    sha256 cellar: :any_skip_relocation, big_sur:        "21c6dda8d31beec4fff96e112ca2fa59e3c7ebafc2300e8a4d639345fd9c89b3"
    sha256 cellar: :any_skip_relocation, catalina:       "06a1000d0a88b1f437b6c91b303a39fff1d701c974bf50a0b91cf15650df3eb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "713b9dccd756b0ba3edc3479ef156de961425ccbdec827192f60075114a8ef1d"
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
