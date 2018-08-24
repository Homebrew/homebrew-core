class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag => "v0.15.0",
      :revision => "23cbfa503d856f57a3e00599d53c04fe69c93cf0"

  bottle do
    cellar :any_skip_relocation
    sha256 "850187ca982ac53209d434c3a468235c1345dd74bee1ba7f348df298ecf47891" => :mojave
    sha256 "140b7ea62f0038ffeaa2ced0dfab9184c3cb2f82f01e5ad873016bfa5bf209db" => :high_sierra
    sha256 "9cb183af9d970e678068d00a1b4d6b171d11290f87b3c52cb9e7497a02a8d1f5" => :sierra
    sha256 "3add0c804ea9331e002bcdf0c246facbeef75d9e2f0f5a2584193f4bd8b420d1" => :el_capitan
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
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
