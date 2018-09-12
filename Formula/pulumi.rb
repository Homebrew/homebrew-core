class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag => "v0.15.2",
      :revision => "8ef626503359c4039b45f1296958ecf6e6630501"

  bottle do
    cellar :any_skip_relocation
    sha256 "f00c4665b7931082d8361c843ff1d518b5ce77daa7c2e31d9a4537dce4bcc54c" => :mojave
    sha256 "1733e97a0dae170033b778f4b29c2c70d8c24ba9aedc86f612ae51371f61d93f" => :high_sierra
    sha256 "cf711e7d9f2f28b6a97b3f12783553eea977164f0174b591a3b738cd45674b93" => :sierra
    sha256 "57a2895209b5c1e22751664d248eba4b6a0c084a0054952a3c4485bd6ee5c0ce" => :el_capitan
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
