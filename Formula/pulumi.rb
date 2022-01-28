class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.23.1",
      revision: "ae247f8f2e5cb627e1ba92e2e603daf166ef37bf"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64626978df335ad9fcc30b297c42e56ef3625a44148af061de65c152ee448e81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9193ea8bb57560665276d83a83118c0037c13a86c6608da64e3c8ee26b0093c"
    sha256 cellar: :any_skip_relocation, monterey:       "182c406546d33739b8f634cf86ed196464edf185301e49c46c044dd180ab64ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "f26e89bb6af4be095825c4994c83280f97cd2846ec6c0b933c845121cb2e8044"
    sha256 cellar: :any_skip_relocation, catalina:       "6f78a3062d55fdca46e84ee29ab0193ea7362c3383bb5ff022e5acc3dec4d8b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0be89a030888788ddffcd830f558a73695bca417f147038d9da2740e9560afe"
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
