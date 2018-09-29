class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag => "v0.15.4",
      :revision => "da880eab6c0df18f476c8db2ec51da7435aaf807"

  bottle do
    cellar :any_skip_relocation
    sha256 "85dc79038613f60ee742fa7dcd4e5c5be055580388d4f355043498c847173bb0" => :mojave
    sha256 "a9663dfa10bc2f3e4ba5a23f2096cfff9111e4cb71b693782b2798e948d33657" => :high_sierra
    sha256 "e7e25ac9e5f0c50781a6081c11b7857df1ed108c1ed69c398ee24939f3a4f215" => :sierra
    sha256 "0b731ecf3614cf3290fe4027da993a2010aa79acf5852c35bba2ac7d57a77259" => :el_capitan
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
