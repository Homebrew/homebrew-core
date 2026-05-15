class Doppler < Formula
  desc "CLI for interacting with Doppler secrets and configuration"
  homepage "https://docs.doppler.com/docs"
  url "https://github.com/DopplerHQ/cli/archive/refs/tags/3.76.0.tar.gz"
  sha256 "cc8c3a2abb9f7ade57cc42ba67cbe47ff6a35270b1f7e4af2277e7cd94dc72f8"
  license "Apache-2.0"
  head "https://github.com/DopplerHQ/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5cb933eb03cfa51bdc1713c2740a030941511f01007b770c05ee87751a8ed0c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cb933eb03cfa51bdc1713c2740a030941511f01007b770c05ee87751a8ed0c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cb933eb03cfa51bdc1713c2740a030941511f01007b770c05ee87751a8ed0c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "2476285a16b493a1fb4432f2835b77544f8f0a6cd4e93536fe00eda68b970194"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c1fd662c820af3ec1acd2542b2e2211984548fdfed533b5ef223c491c989cfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34812b409f11d5252e08fedb251f28bf4446fa0f2dfba0112f59fd61ceabd402"
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
