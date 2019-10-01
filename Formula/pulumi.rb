class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag      => "v1.2.0",
      :revision => "dd8155ae20f482d6980cc9c2c1407a72bcc40a99"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ef8c93aef86fd9bccd9b594195d133231f85fcff715f61a847f357a3ccbcbf8" => :catalina
    sha256 "7b4e0abf687ab7862f89a3714db3dc914c540423f18ef0ab01e5e8e6f7682aa0" => :mojave
    sha256 "c6386d63addd1e8b14d35d5981ec2b9f9e0dc1b8b4a8124f72babcfd46eb9473" => :high_sierra
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
