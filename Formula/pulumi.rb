class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag      => "v0.17.11",
      :revision => "f6c25b7d2dd881ef892ce03b5cf1ca579b8c71e4"

  bottle do
    cellar :any_skip_relocation
    sha256 "3686a4047aa7578e69863f1e0b296b059480a7c2160d35172e30b035a5cd1a45" => :mojave
    sha256 "35d31fc7a410bfd2d944f4ee1aa4a3df2e84237186562e1fc8dabb94aaac5535" => :high_sierra
    sha256 "59647fe79ae8852f3ea21cb0acd075c0a007640fdc9017d937dc25c5148634e4" => :sierra
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
