class Doppler < Formula
  desc "CLI for interacting with Doppler secrets and configuration"
  homepage "https://docs.doppler.com/docs"
  url "https://github.com/DopplerHQ/cli/archive/refs/tags/3.71.1.tar.gz"
  sha256 "8c9b2c59935b80480797f3b09d1ee3a9366884843a7b3c9e06aba9c32434fc34"
  license "Apache-2.0"
  head "https://github.com/DopplerHQ/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4835b03ea84efe435162237df55c170988630c96179a57f69f0ed22d20260a18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4835b03ea84efe435162237df55c170988630c96179a57f69f0ed22d20260a18"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4835b03ea84efe435162237df55c170988630c96179a57f69f0ed22d20260a18"
    sha256 cellar: :any_skip_relocation, sonoma:        "09afe3d0b87ac195c3948f4a8e4f28e9ae7835459fd41accbe8b5fbcf232374c"
    sha256 cellar: :any_skip_relocation, ventura:       "09afe3d0b87ac195c3948f4a8e4f28e9ae7835459fd41accbe8b5fbcf232374c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d101ef65476ee9b8da68ba0d62eeeaba94205d4ae93c43cfd1027978f0d1e7d"
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
