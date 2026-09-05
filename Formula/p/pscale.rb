class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.329.0.tar.gz"
  sha256 "ff53494ad04bb3e5d116676710d7b23509e0f6c3bacc59837e0c4e9435e4784e"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed14c82abc8b329ec1a7641c423c1d549100398f5c35839a752135c223b6c530"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eacaa9edf5a318267c6037a8224a247f74cc2eb6da27f655b1f6f1d7d41e2135"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d1f485b180831da00e3a7c265e88bde0e9d448075088b5287373dde148c565f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4733c92231f54b55a74d02d448a286a6dc5b027189f7d3ec740199e57b690907"
    sha256 cellar: :any,                 x86_64_linux:  "18ea870fa71c87a09623b79a188f867a99e7ee5284cbf69558237e966ac325cc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
