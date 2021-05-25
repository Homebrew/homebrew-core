class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.3.1",
      revision: "9a96d3c5e1a2e86a00aeb6013c6677fb20f55a81"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "326db10c02aa31f162bfaf68c80fdd99241ea9d8fecbbb5479f85170322febdd"
    sha256 cellar: :any_skip_relocation, big_sur:       "d83ec3b668528cdf59b45f87d58fe5237532c8c4934dbd8f6f53f3add775518e"
    sha256 cellar: :any_skip_relocation, catalina:      "a481e1c9dbe405c0edcbe4ebd57529ad9e65fe27e2d00bc41b6a2ed7ad274c09"
    sha256 cellar: :any_skip_relocation, mojave:        "451177310b59896c1b597eb6bf51afc5383e93bf9d5d50008029fda5692ec3ad"
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
