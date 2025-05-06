class ImmichGo < Formula
  desc "Alternative to the official immich-CLI command written in Go"
  homepage "https://github.com/simulot/immich-go"
  url "https://github.com/simulot/immich-go/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "1887a6e1be06d65d955c31cc24b714608e3e28c86811a624763de10aded83d09"
  license "AGPL-3.0-only"
  head "https://github.com/simulot/immich-go.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e9ab51772ada53f2cec07b49bfbf3d8c50639694d1f4181f01e00259464a33f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27835b15dace08af282e5fe1ebb4285ec2bb620ef0c58e36ab74b0ca047d983e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f8497d80f35d0cbf0f96aaeb9f3b2a224bc8a6bf994356fbd163099ed8e2d78"
    sha256 cellar: :any_skip_relocation, sonoma:        "147e658b390382e73217852e4f2a77089b025d69039d7ab98ccaabe4481c4f9c"
    sha256 cellar: :any_skip_relocation, ventura:       "fb68d3ed6eb43da4b47447ec18bd09060b3e8a694e81b8a10cee899b8d8c7667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "806424b0dd414394ff5052ec34b0977e06ec25f644fc025e1b5940577806132d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/simulot/immich-go/app.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"immich-go", "completion")
  end

  test do
    output = shell_output("#{bin}/immich-go --server http://localhost --api-key test upload from-folder . 2>&1", 1)
    assert_match "Error: error while calling the immich's ping API", output

    assert_match version.to_s, shell_output("#{bin}/immich-go --version")
  end
end
