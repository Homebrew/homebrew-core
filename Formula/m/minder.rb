class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://mindersec.github.io/"
  url "https://github.com/mindersec/minder/archive/refs/tags/v0.0.68.tar.gz"
  sha256 "75f7bd3a9be5c404a53d6df33cc747a1c4158e1a0183fc8cbe4deeb3281c3835"
  license "Apache-2.0"
  head "https://github.com/mindersec/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9af18ee00006b2ace9429391f0e6ecf5c61935075c8c40ec177741987df9e694"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9af18ee00006b2ace9429391f0e6ecf5c61935075c8c40ec177741987df9e694"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9af18ee00006b2ace9429391f0e6ecf5c61935075c8c40ec177741987df9e694"
    sha256 cellar: :any_skip_relocation, sonoma:        "44230b8994321ed0479f740dde94eac01a286bc3c7d2264bfc79405ce31bb254"
    sha256 cellar: :any_skip_relocation, ventura:       "13851e641d75942ea5e0a3ff2f5362e1f32f87864f8c228c817a3088196f7c44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19bd76ecfc93bc0be8f79adcfc4477f0f9752b8ac2b8071538b694bb6223f50a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/mindersec/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version")

    output = shell_output("#{bin}/minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end
