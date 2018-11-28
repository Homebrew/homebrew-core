class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag      => "v0.16.6",
      :revision => "3e913d2577979ef8a8a05e177b9f46d29707eb40"

  bottle do
    cellar :any_skip_relocation
    sha256 "3b2f76a176a68aa5712ad95d97cdc2a0d02cc2ce9355861a4c8dfadba9d5a460" => :mojave
    sha256 "bffea99f706f7af2f6dcdf25d3605b9256593a7ff035333c5eb3095d2d098660" => :high_sierra
    sha256 "957ab8344d1731a5c0a1c001e1b4adc8c252c1c999b2a15c5f03b1dc90ea5c9a" => :sierra
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
