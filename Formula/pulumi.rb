class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag      => "v0.16.8",
      :revision => "d2bd696d1598d7b460f37ff84a49b28ba65e7669"

  bottle do
    cellar :any_skip_relocation
    sha256 "25222769e030eba59b101090a46d15c24d3b58db398fc9d76cfbc897fd43adf2" => :mojave
    sha256 "24c35bc9d49b3f66aee969d7eca4c52e09c965e7c2d5691e998285edcb10d843" => :high_sierra
    sha256 "b6e7a274e81fdff2700fce84ac21a40dfe3855979f01f22140d5822fd340eade" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/pulumi/pulumi"
    dir.install buildpath.children

    cd dir do
      system "dep", "ensure", "-vendor-only"
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
