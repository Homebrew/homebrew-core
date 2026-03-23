class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.276.0.tar.gz"
  sha256 "57b5455e16c588af1f697ffc49cf11379786f18679abc31f572629dca29966d7"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcec2de500f785eb73a24417b9eea700d7e3060a7ae31f30a2f9a98c9fb23742"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bfb681c8fdc3d47e4067066a3f7073b8f0fe26a7bd3112fd676a60c2967ab9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bddbc5ad45ea594cee4266dee8f39ae0df2a448bd8e9aabd700a261e7102c8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "32be671240282ce2f7bec3b56de8502f35b98e1cbbc64b052710d8c7d016b9e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80351c9432b88bcb07c03bcda415b5e6e4f203ab9e291b7c93d9070b5641facf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e4bb46fd374c085417a4e4ede5a77f5346e05a58f4375f0b99925c9d1575a6f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
