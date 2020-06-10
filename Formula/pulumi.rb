class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag      => "v2.4.0",
      :revision => "e0bf69b77a134f0c09575c8971373e04306a1dd1"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2680006af27ee77ca319d2a6b0ebfd5c302a53f82efc1eb60782a6d53ce64276" => :catalina
    sha256 "1ad3345412d9dee1706a1cfde858d532ffc520a723464d8565ef168381e7b46d" => :mojave
    sha256 "b72ed88dc6049e890ecf025ed03b57c519bf415269f82152ebcb87d425e0f4fa" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    dir = buildpath/"src/github.com/pulumi/pulumi"
    dir.install buildpath.children

    cd dir do
      cd "./sdk" do
        system "go", "mod", "download"
      end
      cd "./pkg" do
        system "go", "mod", "download"
      end
      system "make", "brew"
      bin.install Dir["#{buildpath}/bin/*"]
      prefix.install_metafiles

      # Install shell completions
      (bash_completion/"pulumi.bash").write `#{bin}/pulumi gen-completion bash`
      (zsh_completion/"_pulumi").write `#{bin}/pulumi gen-completion zsh`
      (fish_completion/"pulumi.fish").write `#{bin}/pulumi gen-completion fish`
    end
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
