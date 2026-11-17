class Oasis < Formula
  desc "CLI for interacting with the Oasis Protocol network"
  homepage "https://github.com/oasisprotocol/cli"
  url "https://github.com/oasisprotocol/cli/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "3e8aba8dc9bed9dfb89c0ee970227e16bd2895959c78a2388b53efe8e87f0e2a"
  license "Apache-2.0"
  head "https://github.com/oasisprotocol/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aea3e83dea6d8a6a0b838f5b0e2008a19ba142f075f66924202f8e35bf021bb4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "662de56657d2009c663a1eaf5b7c935836c7f56bc204277e1824752375f726e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2d986d81573ebb559ce976b4841c97bb8889f90fc164be9cb135863970ee65f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "81d3fe04b0511406dd4fdb21341f34dfd35dbb7df87a83b134a396ab4da0e07a"
    sha256 cellar: :any,                 x86_64_linux:      "c16307ba29666b74e0877d9336cb7d55a4c6ef4611c44d1ddd88d7d4fba18e6c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/oasisprotocol/cli/version.Software=#{version}
      -X github.com/oasisprotocol/cli/cmd.DisableUpdateCmd=true
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"oasis", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oasis --version")
    assert_match "CLI for interacting with the Oasis network", shell_output("#{bin}/oasis --help")
    assert_match "Error: unknown command \"update\" for \"oasis\"", shell_output("#{bin}/oasis update 2>&1", 1)
    assert_match "Error: no address given and no wallet configured", shell_output("#{bin}/oasis account show 2>&1", 1)
  end
end
