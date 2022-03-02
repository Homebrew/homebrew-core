class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.25.1",
      revision: "77886c14c6adfba1c6ec6429e6156754d0a4a378"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c518555f53eac4c3b3bd7bad0c79e7becca30813d8043abab7b7748b2102de8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bd1510a6627738e394f604c8022d0d46ef26a868744284d01b19c29fa00b73c"
    sha256 cellar: :any_skip_relocation, monterey:       "3869261dbcb72e68d1ba981064ddcc9343852848335dbe05e3e3ae5555cf7bfc"
    sha256 cellar: :any_skip_relocation, big_sur:        "7af164c40a1687c2e88f36757eefce837d89b3963abeb35023b1a40840026534"
    sha256 cellar: :any_skip_relocation, catalina:       "05d9bab60c39f48a9efd24840e64ee89c115cec1be71db15cdb089a7c376a559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7339ef39e3df8e3192cb3c457af00b48fa1c573007791ad92297088a596383e"
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
