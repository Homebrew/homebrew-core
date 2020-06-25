class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag      => "v2.5.0",
      :revision => "ad721d3b5421b2a7b10a0dfdd8abae8cf4b80e69"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ead3214b299284e29640f24c2b8f7719184a17b2aa2c156a603348cea015fc7d" => :catalina
    sha256 "a803a6b7c0015461f5f0fc0f5edde1b8f13bc8924e107341bd1ab8fe0b9be107" => :mojave
    sha256 "e8487e22af898e516b625d1d725652d577d24ec5283a3eabaf1f7f8feb27b440" => :high_sierra
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
