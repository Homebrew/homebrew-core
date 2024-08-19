class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.129.0",
      revision: "f31c50eba22878efdf137b2195ca733ba37d5fad"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "801902b32216976fc844fa67fc58035cc5ef5277e73bb900a721057a2c2c3a66"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d70b7317b523778c7a492d657f0e8034cda6ad1ff46dc0e013b3d407564ce060"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd096646df54b29951b5d0952fc81fb74a3f519c897a48d718ad42dfe95034a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "db79be88c4171e2661710217a2cf82c5f038d18ae6f348153fe2dd89721920ed"
    sha256 cellar: :any_skip_relocation, ventura:        "7d5fc6b6ac9e9d590a7ab0167a97c0ad283fbd965a03fad73831a0d289831e51"
    sha256 cellar: :any_skip_relocation, monterey:       "2a34d439db572f7ee432a9293868b1e19a1a600f1a80e77c2b82788c9f3e922f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9dbb92ea8791b786163b737fd6451c47f9bc0909f1b97b949642ec132997d52"
  end

  # use "go" again after https://github.com/pulumi/pulumi/issues/17003 is fixed and released
  depends_on "go@1.22" => :build

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
    system bin/"pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
