class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.229.0.tar.gz"
  sha256 "d1dd3368d6fb6f66acbac866d9e27c0f43862b435c5201e90f0ca918f4df9c19"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b58b6bafbde47ea242215ed54e1808188cfa97c46682366686d661d7a7c5ac7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e660b64c83ea63c19a572c9c95c5479207b0b7b083a32e001bda687a92fca333"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7e2babe121ded58d3347a80f61e24a99eed23c718090120c4022a29cab4a431"
    sha256 cellar: :any_skip_relocation, sonoma:        "147a5fe8ebf6af75ae23c4ffa333d815a318e8fa9682fc2012a5f5adb7bbcf5c"
    sha256 cellar: :any_skip_relocation, ventura:       "9348a31849cba84ee8f295dc97060ba674da94d3612d1264f8672fd980ee9ffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d2a68427bb6c5f806c939b10220dc6071a646bda4ce25e2a21e923b875eaf72"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
