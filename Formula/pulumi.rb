class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag      => "v1.0.0-beta.2",
      :revision => "fdfef5f334deac2cfe83288a99f22b73995ae736"

  bottle do
    cellar :any_skip_relocation
    sha256 "a8ec6cff20bd6d66a30a05d40241a58bf82b337a7c143456b2814ba781dc0a8e" => :mojave
    sha256 "5811623d39a366bc2b17efd2473e7b9e4617f5ac71c445bc38839f7f21f8e990" => :high_sierra
    sha256 "4656bb975e7834c7cba61f013a68b496aa800cf3ab778dff74a56d0b43453ac5" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    dir = buildpath/"src/github.com/pulumi/pulumi"
    dir.install buildpath.children

    cd dir do
      system "go", "mod", "vendor"
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
