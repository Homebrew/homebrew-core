class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.37.2",
      revision: "0ba7aaf8c789d787267e75ce8c938d0de067c311"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f361fe8a723e60bb4737046f840581d7e5c7102af6ecd5888252a35a224c76fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a79afd8a924f341c2de6c406d10f325ac377756ef5c64468484e47d9470b78d"
    sha256 cellar: :any_skip_relocation, monterey:       "439d8e5e945f747ba4001a2e5856985744e49c99ec2fba8de88c683ca9a1afc0"
    sha256 cellar: :any_skip_relocation, big_sur:        "58c96870fbf5d1b1e1419be541c501e4c23c9d2548912a67baad0a44fac39ae9"
    sha256 cellar: :any_skip_relocation, catalina:       "8c1eb843161bde77dc78d7f591a7c07d043a5e75917e4ea15dea6f4fb06ef767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a66f4253cbb3b847c95a2036af070bb161e6fd31b65444428a0aa7b52ae1b01d"
  end

  depends_on "go" => :build

  def install
    cd "./sdk" do
      system "go", "mod", "download"
    end
    cd "./pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}/bin/pulumi*"]

    # Install shell completions
    (bash_completion/"pulumi.bash").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "bash")
    (zsh_completion/"_pulumi").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "zsh")
    (fish_completion/"pulumi.fish").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "fish")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
