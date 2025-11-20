class Doppler < Formula
  desc "CLI for interacting with Doppler secrets and configuration"
  homepage "https://docs.doppler.com/docs"
  url "https://github.com/DopplerHQ/cli/archive/refs/tags/3.75.1.tar.gz"
  sha256 "1487ff5cbc24a398f746a0fa07261abaaee89acffbf3861801f8c3cc58fde122"
  license "Apache-2.0"
  head "https://github.com/DopplerHQ/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8ba3844a7e3281b2c003efb33aaecf3aa903fe193f5e091fb70b01899b68310"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c6c9327df7c0c4b1e8c497fdd3acc7d8fb13c34fa8d38d6733e1203428b31b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c6c9327df7c0c4b1e8c497fdd3acc7d8fb13c34fa8d38d6733e1203428b31b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c6c9327df7c0c4b1e8c497fdd3acc7d8fb13c34fa8d38d6733e1203428b31b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "bff18de552956fa3893a9f8eb2da726de251d7c20429798224eb3cec82e8dfe3"
    sha256 cellar: :any_skip_relocation, ventura:       "bff18de552956fa3893a9f8eb2da726de251d7c20429798224eb3cec82e8dfe3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "321133b6771e1ac26d4324c8cb1dc579cba7d9dadda04dfcfb771aa8727a1e74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08ce028ea8d6d035e69508e1a66294e84cc2fc6a14f9e6f29ea1e4c836ebb6bc"
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
