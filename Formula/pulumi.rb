class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag      => "v0.17.16",
      :revision => "e8a5acf1f28d6bd467a49fe6fb894c1e49db6cdd"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e236d1524d31747c21ce69e0e1d2328befe094c66d9a4a7872c536cae64464a" => :mojave
    sha256 "a31fd22f99ab619cb4cdd3aa8040225e6f27126944396bef4e7426086e5c7bc8" => :high_sierra
    sha256 "ef43ada00788988715afe32f1a262fe53b32abb30cab01f399b9a275d60dd8b6" => :sierra
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
