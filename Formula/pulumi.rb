class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag => "v0.16.1",
      :revision => "35bb7d39641c60ce3b1c75c933814f8458f0a182"

  bottle do
    cellar :any_skip_relocation
    sha256 "d16b7f9998bf02860db9e244e61926ad0b73629b4db6922dfe87300301b15c41" => :mojave
    sha256 "8e1aa055a840c21c848bc39261f6d0a55a17631c4953889a2235a7242906d3c0" => :high_sierra
    sha256 "8006879c12cf40294f6dcdd70d3832c0c381dfc83807e33e81786dac0788470f" => :sierra
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
