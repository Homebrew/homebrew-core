class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.46.0",
      revision: "91221400a3c95bcb00a86757f8850f14e5a526dd"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93160369ad5a91b92cfe26e68818d09c3fac077534d20470d8599f0fbc0cab36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ec76357e24d6dedd7bae7c08baa05c01f54bc92164b0a252177723b1a3ebfcd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0a9e95bd18d8c3bae58946de93018d18a9c6d355cb1e86224748a8b14d9579b"
    sha256 cellar: :any_skip_relocation, monterey:       "babf79c693eac875d3f111a88abce3d70078ff53c739db2b9865c105b909b26a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0876e653639fb12334fb5a1bdc25a5c09b103cf5ad5834305d92ea390fb66607"
    sha256 cellar: :any_skip_relocation, catalina:       "200dce7c72325d8c6f6b633ea11d3fbcc8dcce26deb0762a6d17543d0e2c3ab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0cf0df6eb3e2d6934a037949f5acccc76a4a5d7b5dfde37a748dee488e99a25"
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
