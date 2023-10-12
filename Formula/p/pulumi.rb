class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.88.1",
      revision: "b22087715f4ba036cdf323de7d44a7bf9c03f144"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc4ca021648f190195581e8f9258290664d38c8f2ee5da9b0c39479135482d2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bfea3d436d9aece642032f99b2ac4e932f9d254a790e629e00ada540ba4bd33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdd6b977b8e8769c8978e5caa28839c05866fb9485b2fbb0356ec7dc90d7c735"
    sha256 cellar: :any_skip_relocation, sonoma:         "24e18833024a93a5da4f293e3384016e587955c01558adcb3d538631b9a0d26c"
    sha256 cellar: :any_skip_relocation, ventura:        "b0a00a64531d1dad73d9ae9887ef8fa84342b13e2650a40f9d98b36b7d3768c6"
    sha256 cellar: :any_skip_relocation, monterey:       "302caa4bd701c9cb584b219d9fef95733df2090a1d54d8293bf44d0f59ab69ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c40796df09980e31db80e0edc5e793de606ea4c5c4caa172e6eb8287dec46f1"
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
