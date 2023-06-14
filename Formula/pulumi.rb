class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.71.0",
      revision: "cec4af940f8c5961e264bc49de5ccbd3bddea1f0"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0aa7866d1aa28bdee8eae85f95066f3b4831f7b342e47f473e8925d05071bcf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84d2c6c3353d595ca4107b13bb4347b86e5f165b6e8cb08f0094005f63c9781d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3147ab3698899fa7e206e21babe468c8ad394b33b0648551335118f52638fac5"
    sha256 cellar: :any_skip_relocation, ventura:        "216cc91c70e3199d7553e508af8f6730105f844b2b6077aa89af723f9e96da57"
    sha256 cellar: :any_skip_relocation, monterey:       "3c15685bc6ce7912438e377645b346f5b74b0cedaac3ee7ca948be022dceafa4"
    sha256 cellar: :any_skip_relocation, big_sur:        "2073383afcf07f195fcf9fd491e02a5a0aea7586dec30a0fc843d5d8cdf549f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "719dc784a4ee1827ab70d59ea1f7f33218f0c3f38f98a119090b16ec0e6b4cee"
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
