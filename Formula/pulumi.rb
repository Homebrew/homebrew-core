class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag => "v0.15.4",
      :revision => "da880eab6c0df18f476c8db2ec51da7435aaf807"

  bottle do
    cellar :any_skip_relocation
    sha256 "b93bf95e4dbd91040526e401519f9e9a82b8f298f0fed20532cf741423f5c109" => :mojave
    sha256 "b6b7d5cbc9e56dbee252fdbe13a84ecc49ff7d438960755c31763e2a7608938e" => :high_sierra
    sha256 "6a6321c90fad57876602f02fd8c6ad472f47fbec935c555f8c12f5adece9ee4a" => :sierra
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
