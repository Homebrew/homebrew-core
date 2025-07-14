class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.18.tar.gz"
  sha256 "39ca1320d30ad7254dde9678f2d3d6e32875155f76bef4e4c115d3d6ee988504"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82803d89558880ee007e75f2fda666e21fb53d8f6ee086bfd225172273fbf9a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49edff99b042cf4f4593491ac41dc770cb380c0301490ac12cd2969c10b496ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "acddfc8cda0d2c2019c3aec163c3220773adfbe7f5cdf1e15f9935dc5a747f3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c57770e895f0c8a91e76ba48dbea95787f4506c0f0b142a7429ba9dbb72e4e6"
    sha256 cellar: :any_skip_relocation, ventura:       "3057b121f6362800ea232eb9a1953aece992b5a7d4e081073639d768106143c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f89af14980868c24bc61156345753d3e6ed814012d05a1214ece93c0e6e83c75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baff2e88299338fe9ae96ffca268cafe5cafb0c211a2c958f670847ea498fb54"
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

    generate_completions_from_executable(bin/"kosli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
