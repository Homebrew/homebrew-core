class Pulumi < Formula
  desc "Define cloud applications and infrastructure in your favorite language"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag => "v0.14.3"

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "node@8" => :build
  depends_on "pandoc" => :build
  depends_on "pipenv" => :build
  depends_on "python@2" => :build
  depends_on "yarn" => :build

  def install
    ENV.deparallelize
    ENV["GOPATH"] = buildpath
    # Remove once opt/pulumi/bin is not needed anymore
    ENV["PULUMI_ROOT"] = buildpath / "opt/pulumi/bin"
    (buildpath / "opt/pulumi/bin").mkpath

    contents = Dir["{*,.git,.gitignore}"]
    (buildpath / "src/github.com/pulumi/pulumi").install contents
    (buildpath / "bin").mkpath

    cd "src/github.com/pulumi/pulumi" do
      system "make", "ensure"
      system "make", "only_build"
      bin.install Dir["#{buildpath}/bin/*"]
    end
  end

  test do
    output = shell_output("#{bin}/pulumi version")
    assert_match "v0.14.3", output
  end
end
