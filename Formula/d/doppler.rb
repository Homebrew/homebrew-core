class Doppler < Formula
  desc "CLI for interacting with Doppler secrets and configuration"
  homepage "https://docs.doppler.com/docs"
  url "https://github.com/DopplerHQ/cli/archive/refs/tags/3.75.3.tar.gz"
  sha256 "3076fea5586209cad7b4d2dc3eb1e7cf69d9349e8acdc28d50c604c3932015ce"
  license "Apache-2.0"
  head "https://github.com/DopplerHQ/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6a1a5d4ef217351f08508db2a5340b06367a30db67b7c19dbe9e00cf50279d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6a1a5d4ef217351f08508db2a5340b06367a30db67b7c19dbe9e00cf50279d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6a1a5d4ef217351f08508db2a5340b06367a30db67b7c19dbe9e00cf50279d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc79bf83e56e604cea772678eb9f228100dd9fbc9fb8c8c7aa1d3e7ee540a912"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "729fe36a5b099805f7271f55efa4fe5281f3a93dffcdef65ea000a536358778e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eba3e1f9a780e2b6fdc024315f379d3b0903fae00f02ffc106021a5e778769f9"
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
