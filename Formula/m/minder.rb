class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://mindersec.github.io/"
  url "https://github.com/mindersec/minder/archive/refs/tags/v0.0.89.tar.gz"
  sha256 "8cc2ecfd5730d6718d8ffd54b4557aed84f2aa36d524783767345018341c1b84"
  license "Apache-2.0"
  head "https://github.com/mindersec/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1aaf51fbcb5e872ab87fcb71067b8e1499c2a4ea836504be50ff393b42ee8fe8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1aaf51fbcb5e872ab87fcb71067b8e1499c2a4ea836504be50ff393b42ee8fe8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1aaf51fbcb5e872ab87fcb71067b8e1499c2a4ea836504be50ff393b42ee8fe8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5fe2cbeabb3a3d6840a25d5c91a8d289f98a9b088da2d35c627fa832e614dd6"
    sha256 cellar: :any_skip_relocation, ventura:       "41c7932e9dd3c308c4c87ae6246e7338f4b09cb2312a0d72e925e5e15599898a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fffc005a4f80bc0ad7392a7e80cf7ecf87d4c1a7a4155cdf6a3c88b09d345d23"
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
