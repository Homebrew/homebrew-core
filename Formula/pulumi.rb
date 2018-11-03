class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag      => "v0.16.2",
      :revision => "072a0798335a36196ba1696c41576d7059c4cc7f"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "34b1d457f9f7f4116e8220f425f85b7fa1848d7b5f9f3f6ec2db7d77abbfe0c7" => :mojave
    sha256 "43c869101393ea97e311d6fd422d4a9a95a8410cced67ecb71e5b58a17fcc967" => :high_sierra
    sha256 "dc4ec62dc3ef62530f5dc20d5da5b67d8fbfa256d8b2f56a0043ea6bc2b7eadd" => :sierra
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
