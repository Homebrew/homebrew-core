class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.113.0",
      revision: "44c8de53d5d216e1a25926e7e104c805b592d37b"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b31f31b0cfd3c7fa8d7fd6b5bd6c4e815f99a511926b4d25b9972d70481df11"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f7d7da1d7ff5c502f6dbc779b2649f9fc370924c0cb30f0bb43247aaa6c3164"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1489d8e32e2872bc1cb18ca2f930118aa4c2e1b62431ddb55acd95d94c743b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "589ae7fb46696f24908f7848b0e3f7dd74db0fbf37a6461d3fde0ebe7854e88e"
    sha256 cellar: :any_skip_relocation, ventura:        "eeecccf2cbf36fa32b78ca2e2f936f576c6270917d0054d8d5f8d072d1132770"
    sha256 cellar: :any_skip_relocation, monterey:       "472a58b9eadec1934cb66d270cfbd4fe9897c79ce8a76e998351d34fbbe91e8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1399a40c5733a99df7c0f9099f73d69eb03044fa8ed116f8c8a808a65447540a"
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
