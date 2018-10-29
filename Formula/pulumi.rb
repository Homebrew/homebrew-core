class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag => "v0.16.2",
      :revision => "072a0798335a36196ba1696c41576d7059c4cc7f"

  bottle do
    cellar :any_skip_relocation
    sha256 "aaae4f77b1591eab0ecbae11c98031bb3db3256ff580e73ed17559122f4e36e0" => :mojave
    sha256 "06c607d60024dd2e404e2c76bdbaa00e8e4b0dd5e48370aa285015d976ba7520" => :high_sierra
    sha256 "65c284f6c35db91f2e3d9c3f8ff752918a1d938497950ea70040b8a21c60cf2b" => :sierra
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
