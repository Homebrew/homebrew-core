class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.8.8.tar.gz"
  sha256 "c7ebf3a2d7fe1a3504f26612e8d3c4382c0ad63d14885ea3fdbe22c519a97cf1"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a44945dd3c62f687ecb7acf446347c1c5c90331e6c775c3a3b2fa65ca155556"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7fd1e315611000e3b0b7adc864a25d699b5cc047c83660f63c57fd00a97082b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08b1209c70af07ebf0746c5dd6b70398a5c9477e242f027d6b9415b2c95b186e"
    sha256 cellar: :any_skip_relocation, sonoma:         "a79d765d63e5c579efa64fcd2743a91498d4b7272f2b4b813e8b80115c40584d"
    sha256 cellar: :any_skip_relocation, ventura:        "49452e853e3a244ee2d6f6e1d5296672bb970483b8a26b69fcfeb61621c47a90"
    sha256 cellar: :any_skip_relocation, monterey:       "30e321156d6c9909628c921d6ddbbdb845c98f53be8cfd6b12cbf4aef8ad8f55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0de37f5885ff5bd1b028bdbf57151538041d51188856cfed09d56cbad62495a5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
