class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag => "v0.16.0",
      :revision => "dfdb10393ad0c4a66bcc5d877a7ef76eaca586d9"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b7c0e7079ff879a799bc72b3e7cb003bfb01c9f3fef383c7eea8d7f97089dbb" => :mojave
    sha256 "24b239afc1150e31890b126b5e62d2dde7aa65ee8e04c9aeb208647f7fb198b6" => :high_sierra
    sha256 "cc67950abf53949cebc6d15f87f3bd18c025510eb9c83951cca04bdad44a594f" => :sierra
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
