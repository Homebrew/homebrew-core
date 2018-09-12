class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag => "v0.15.2",
      :revision => "8ef626503359c4039b45f1296958ecf6e6630501"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9c3793568e1678d58958bcd6aed14190a59a5dfe174256b6a646de82f585e87" => :mojave
    sha256 "d0423a5ed5f5b88d9b267027c48c273ed4300d145649f71aa7c634c1794e78ae" => :high_sierra
    sha256 "816497652c9c42ed72abe3d5b498bf99854bd188bce124c28e49a67377d68963" => :sierra
    sha256 "c4fb3caad4c8490d198274396f6ff0f9b8fd8a1cd4c136f8cfefc922206bedd5" => :el_capitan
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
