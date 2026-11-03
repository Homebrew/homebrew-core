class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.349.0.tar.gz"
  sha256 "af6299144a8ff375eaf5008f6f15a7c9d10602d23ad6a6e45ad818f8ad58f05c"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c5c067bf5a9d2f1a7f3816ad2e048a279ef8c149e9ee5c72e666b2865dcc899e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "711520c072bb9ea2006c6fd53d0cc36774865be755e01135fa0c1c82b4ed6b20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "27976f61daaeac8506a0cf49b19b865e69fe39a9346e66476efbe59ee389e09b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "850290efb9ee66d8c10da948c9f85ca4448acded7a0a5e3b5e0cc4cbe80b94fe"
    sha256 cellar: :any,                 x86_64_linux:      "1ef8b8b5d354aa2898f710b830e20b94cfe6586fcc5a4ac37586505dc9ab6724"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
