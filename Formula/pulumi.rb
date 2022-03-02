class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.25.1",
      revision: "77886c14c6adfba1c6ec6429e6156754d0a4a378"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "113185a7d1b214851767d57f0535c896e0b6c3f3285ce8f8cba78b51c8358d2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e88fbd3f0045b60c0a59d59d266a7a7080b3fe45f90635252a8daa42775b7cb4"
    sha256 cellar: :any_skip_relocation, monterey:       "20563064304569c66f0b656fdc88a58e1a3be8b3b2a08880594ff999699aaca4"
    sha256 cellar: :any_skip_relocation, big_sur:        "85d760d9d84bdb9c53a3aabc132d222124c9c662aadbe4d7f7039ad8c59719c5"
    sha256 cellar: :any_skip_relocation, catalina:       "b08df118915b17088cf15f1df7eafb77bb7146cbd5dcaff645a4781ecbdc6bd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62f96c8e5ccba0c4aeeea25fd7df70c4ba8465d6c5784ee7a115f7b73e8bffb7"
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
