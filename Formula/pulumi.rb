class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v2.21.1",
      revision: "69915c89ae4726da6cbe9f82483aa86c6c4bf01c"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a65d5fdc8b7ad06e76b166e2bc6aa77e6b0e7ac785a36fa06979f2e52e7be65a"
    sha256 cellar: :any_skip_relocation, big_sur:       "88863cae5724281e873cd19e4aa4a7ccb002edfbf23680c71c7a4e6d118936ca"
    sha256 cellar: :any_skip_relocation, catalina:      "e384e1bacd340aaaec55a0aabb87b74b9aee3e7331515250725d1280486bc375"
    sha256 cellar: :any_skip_relocation, mojave:        "680cfe5c95b1b988fb64e7870d878e951c2420efabc063393fa351cbfcccc4bc"
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
