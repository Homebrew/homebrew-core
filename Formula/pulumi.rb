class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag      => "v0.16.8",
      :revision => "d2bd696d1598d7b460f37ff84a49b28ba65e7669"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5e8722d0adc5aa7e35de13e65daf02ff8b5c16b6e6fe9df214e4026cc5d817d" => :mojave
    sha256 "ac3801cade8b11cbc9b6f46db3f86884afe2f0a92f8f2446d0702ec414636836" => :high_sierra
    sha256 "fafc4db2a292ea64fcd23a313a0432613ca794f64c6e8d32695dbc37eb3a09dd" => :sierra
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
