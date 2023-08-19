class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.78.1",
      revision: "93c70d82ccd6d677a4fcab32a2a97bc05ded1575"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ad2ac041b041daa868bb06d2bc11b5540534507d44218de548ef17da0da986c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71a2bce40759c8f93cb68338b344752cc31571967405cbda4ff43a0c5dcd7a71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abb99663c78c77e9cb61de879c1d73c373f48c0e8990e7ddc21150134ad24aaf"
    sha256 cellar: :any_skip_relocation, ventura:        "3dc2106dea0a012d438a11881beb7b8826c85e2d44ee9d3892b31a30cff318f0"
    sha256 cellar: :any_skip_relocation, monterey:       "63c30bfcc8b1ed25489d566e0251204183bb9d3cf210ac87ecbe4f9f612a7c77"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fafdc5bd4aea6b2804919bee7ab3dd0093e5ca76fc7b44412530aafa33fc7fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97125b01b572bdf4cedd5ad1d1458a626c1b23dc134dece3f11b5e56db023dd7"
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
