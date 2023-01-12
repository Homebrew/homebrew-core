class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.51.1",
      revision: "7efd298867cbbaebf3c8c333e6816e1ea48837ef"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ae024c1a3a55094f2d43a418a295f1ccc6c9138c3aebd8912bf8a058ee66b62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0fbe87fe86db0ad37f990c662339172742abe90e664e3e5aa6eeff9fa402d82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10e642b785f766f919d7e212749632e69e588d30ee2760ee2979f4742b9c5072"
    sha256 cellar: :any_skip_relocation, ventura:        "af3305892f683cae56f351839663aa8ce9bf0fba4074462dd81de9dfd1e071e8"
    sha256 cellar: :any_skip_relocation, monterey:       "3b76c5110072f590f08e8b59087d91a999301c63ce3d3ab349e892c1c7b33f0f"
    sha256 cellar: :any_skip_relocation, big_sur:        "531b4a3e633d022318bbd0f44d2fc66f0b48a50fb25e993db34732bebc2e12d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a94b4a0f3eb9777061f406eda52cf8eceddc2ce4b37677a3d4bd2019d19867ff"
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
    generate_completions_from_executable(bin/"pulumi", "gen-completion")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
