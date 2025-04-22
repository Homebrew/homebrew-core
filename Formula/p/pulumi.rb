class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.163.0",
      revision: "0244fd59db1f42a2d6ba457a42848d81a899fbaa"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ca9cd7eea470719080d569a12469c378480e30fb85286c8400b71a20bae597c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c97e7ae43d9453104e7c5a8a39338910aee3cf0a6a11101ffedbf3660d3f921"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f9e732c50c1ac64707520966fd4365bd6b6e84fb05ace5136eafe2f74cc0abe5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a498abac2703b55176141c794fc01dcc9453933668db3253379e0201ee475828"
    sha256 cellar: :any_skip_relocation, ventura:       "868f57fa41cc7d2220b4c29036f760f3c82ea063359dd1bfdbd6b22d0e7abb14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95474f239a7a2292f6c7d3f3167ac9003f81ca883381de99592f87fd36c056fc"
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
    ENV["PULUMI_HOME"] = testpath
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    assert_match "invalid access token",
                 shell_output(bin/"pulumi new aws-typescript --generate-only --force --yes 2>&1", 255)
  end
end
