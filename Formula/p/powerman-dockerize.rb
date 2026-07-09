class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://github.com/powerman/dockerize.git",
      tag:      "v0.25.0",
      revision: "32d7d8122ba9467d2d2c30bccb56e8217f003d61"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ee3b7c0ad0373b888d8546b103b1172c024fbfba7bdc01a41e1a0e3a6c42d7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ee3b7c0ad0373b888d8546b103b1172c024fbfba7bdc01a41e1a0e3a6c42d7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ee3b7c0ad0373b888d8546b103b1172c024fbfba7bdc01a41e1a0e3a6c42d7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1274b96afd1c1329789476ee26b1277898b46f8b70a3799137259404c48e1d99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3004e46f5c8e486204de9b64dbf83a4dfbf69c36e6438d08303fc49aa6718550"
    sha256 cellar: :any,                 x86_64_linux:  "1b65981f16470c8d0c21eda3a9120b5a44a376c394b14f5733d3299cb9386503"
  end

  depends_on "go" => :build
  conflicts_with "dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(output: bin/"dockerize", ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
