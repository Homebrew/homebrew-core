class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag      => "v2.7.1",
      :revision => "2798bf0ede368cad3f09326276862cf5d4b147a4"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "161555e7aa127a8d49937ad6d22a51ab0f7ef689572be8819bf5d741dbfdfb80" => :catalina
    sha256 "4a823e18aeed4f023d6b18a5b7b56d021c518c542c13217dc68bcfa06f207dbf" => :mojave
    sha256 "642f2a37e9489def4d8963afae9c476ad547b77fb88485c0afbbcd3330aac1f4" => :high_sierra
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
