class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag      => "v2.1.1",
      :revision => "9e91afc2f00e4c4965cc61d3d9a18d6ca9a8396d"

  bottle do
    cellar :any_skip_relocation
    sha256 "35cd2d69d5ac5b6befaab4cb92013f603db610381737bcd87ca23eed4a274810" => :catalina
    sha256 "b870c0be3de2cde8419ccdf73ea25518c1211c4ecf036a70edd74c3d3cb464dd" => :mojave
    sha256 "fbe0c6854d9aca0e5a7648389c6db57628fdae3d42c7ef083a3320fe7d339e7b" => :high_sierra
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
      system "make", "dist"
      bin.install Dir["#{buildpath}/bin/*"]
      prefix.install_metafiles

      # Install bash completion
      output = Utils.popen_read("#{bin}/pulumi gen-completion bash")
      (bash_completion/"pulumi").write output

      # Install zsh completion
      output = Utils.popen_read("#{bin}/pulumi gen-completion zsh")
      (zsh_completion/"_pulumi").write output
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
