class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag      => "v0.17.27",
      :revision => "93f0bd708d5225207655ab7be5f9b5d792c37ed3"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c968618181d2bce59c376f37f91145f315711ec35578e200211e945ce8d47f6" => :mojave
    sha256 "48870a728d0fcdcc201fd9fdabc4c7392a080501faf2b3f710c2a9a45d55c383" => :high_sierra
    sha256 "519d63e93f5691a7e0db93b270b7816d9e156526ed39d918b6a691160c32049a" => :sierra
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
