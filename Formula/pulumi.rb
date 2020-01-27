class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag      => "v1.9.1",
      :revision => "d6bafd5b4b68a0797b7857c57a58419d6ba55fc4"

  bottle do
    cellar :any_skip_relocation
    sha256 "7843d0cb7d08ca62ea08323896eb1549a780c37b96db1dffed6be24023cc2128" => :catalina
    sha256 "a41a90d58f26f0994fb90186e307bbd0fb9b1087614d5fec97fcdc9a4075cde7" => :mojave
    sha256 "6a8ee4d7c9de2c9d15f4de071e92e66ba2a7e9c0ca02e2a5c7d9e00600074bbb" => :high_sierra
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
