class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag      => "v1.1.0",
      :revision => "5af13f9a4f750c6ff3234dae6fedd0b6a0233e25"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ef66ab3d1d3afd06ac2cf73be5448a81136521931e6419e8d6f28d83e262e08" => :mojave
    sha256 "0b0a152a6564a40ddf3c234899b4ec98a85c951e61cd8a73c2bf251722d78839" => :high_sierra
    sha256 "ac354f2c5b6a0a9b6aee24b68fdc59ae0748638aa012277db0905a78556af403" => :sierra
  end

  depends_on "go@1.12" => :build

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
