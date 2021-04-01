class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v2.24.1",
      revision: "ec9353d20ebd881aeb09f8a10ec80dab94c7e230"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "62a89d65ba0571663b7c0c5ba4069d7e00ef81b264adba1b1797e777f353cdb4"
    sha256 cellar: :any_skip_relocation, big_sur:       "0607c686cce7dea40d25b69ac21fee9c69f3564a34e0b457533d85794f3812ce"
    sha256 cellar: :any_skip_relocation, catalina:      "0124256c1354f8de0896b2efb645d442f1bb4b5c25250bc093c3cc4d367eb735"
    sha256 cellar: :any_skip_relocation, mojave:        "48c264a3d672e92bac094a430a930dabda68c9161c70899e97cf3ed61aae4528"
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
