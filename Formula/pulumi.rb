class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag => "v0.15.0",
      :revision => "23cbfa503d856f57a3e00599d53c04fe69c93cf0"

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
    end
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
