class Doppler < Formula
  desc "CLI for interacting with Doppler secrets and configuration"
  homepage "https://docs.doppler.com/docs"
  url "https://github.com/DopplerHQ/cli/archive/refs/tags/3.75.0.tar.gz"
  sha256 "8e484862e225e34fbd1f632aa547322065bbe7bb5a35aa25f94f268939037578"
  license "Apache-2.0"
  head "https://github.com/DopplerHQ/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16c1776f8ba531da5df3be67735536c3f1cc45d111872a91e0ef77f973008ed5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16c1776f8ba531da5df3be67735536c3f1cc45d111872a91e0ef77f973008ed5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16c1776f8ba531da5df3be67735536c3f1cc45d111872a91e0ef77f973008ed5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6dc099de992e5cb5999553896be256a99fd5c57479bbec640a6a67ab337e394b"
    sha256 cellar: :any_skip_relocation, ventura:       "6dc099de992e5cb5999553896be256a99fd5c57479bbec640a6a67ab337e394b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23c23f1560ef0f92b319916ff4e3e6cd9472c574355da71baa48409e41623688"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/DopplerHQ/cli/pkg/version.ProgramVersion=dev-#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"doppler", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/doppler --version")

    output = shell_output("#{bin}/doppler setup 2>&1", 1)
    assert_match "Doppler Error: you must provide a token", output
  end
end
