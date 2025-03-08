class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.5.27.tar.gz"
  sha256 "c18b3c86eebef5a2627d0f761cd7d5f144464493a25ff7c5987e8576a32a8749"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b74b766fd840f83477fb146f17459fb93b7be5aff808a931e115af4e2c6e84a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b74b766fd840f83477fb146f17459fb93b7be5aff808a931e115af4e2c6e84a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b74b766fd840f83477fb146f17459fb93b7be5aff808a931e115af4e2c6e84a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9694c8ac948f944318e3ccdd3d13aabb2c94169ee2a3be1bb9e6f1d7627b8dc"
    sha256 cellar: :any_skip_relocation, ventura:       "d9694c8ac948f944318e3ccdd3d13aabb2c94169ee2a3be1bb9e6f1d7627b8dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "caba9df0f9927ace9ed0e86cfebf08091c4f644505109825d1d25606b5b1591b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cli/cmd/neosync"

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
