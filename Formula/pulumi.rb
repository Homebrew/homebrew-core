class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag      => "v0.17.13",
      :revision => "61bff0c3a4c1b230fb07bf1a4fe32b3c9027d2ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "2636a5cf8e2a6d0b5057946226b47faf7d0e98cb844c399b8e38ffc1ef568703" => :mojave
    sha256 "dd8c44f847e070e5141d18c4279471f057b67bd0c3ff4f44efa2ee3ea29d9bf0" => :high_sierra
    sha256 "c4d6ea94cc287b7c23beedf9346400aed35f0681a06950e94410bf425e76d388" => :sierra
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
