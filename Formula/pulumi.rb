class Pulumi < Formula
  desc "Define cloud applications and infrastructure in your favorite language"
  homepage "https://pulumi.io/"
  version "666"
  url "https://github.com/Tirke/pulumi.git",
      :branch => "tirke-test"
  # url "https://github.com/pulumi/pulumi.git",
  #     :tag => "v0.15.0-rc1",
  #     :revision => "cf93373a84a257e732efa96cc54291eccee87b21"
  head "https://github.com/pulumi/pulumi.git",
       :shallow => false

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    contents = Dir["{*,.git,.gitignore}"]
    (buildpath / "src/github.com/pulumi/pulumi").install contents
    (buildpath / "bin").mkpath

    cd "src/github.com/pulumi/pulumi" do
      system "dep", "ensure", "-v"
      system "make", "dist"
      bin.install Dir["#{buildpath}/bin/*"]
    end
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath
    system "pulumi", "new", "aws-typescript", "--generate-only", "-y"
    # assert_equal "v0.14.3", output
    # system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    # assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
