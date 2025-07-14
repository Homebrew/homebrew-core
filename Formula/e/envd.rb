class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "73d6436a8df10ca5bc00b66a56f3302c138098485808b70d39151d44f6fa10d2"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93e372b202790cd34623e587848c48257170114e33293c3c5277b7e7cccb2644"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f1e4ca522ed6a99f4d53df01eeef5890ab22f1d360386c462aa096ca4d56e57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5feda6607ecd5d84090dcbbaba5a954b4740c5ac8babe3ee3b287922d5e896b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "76f1266d539145c1097a8e14b909d332f68c912b1722e4fa339fbd50ebc035fd"
    sha256 cellar: :any_skip_relocation, ventura:       "e7e108e8a58d98b96021fc0b22e1642a386d485d3a9b8c88de77eb078d9d7cc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f29e31de1d57d37393cff6c9b1b03151352a424ac1dac1997ff04491ead5abef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bbac6f74c72d1a7c4d117f19efb362e8f99b97bf6bc1196fd69415bc26d9a75"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/tensorchord/envd/pkg/version.buildDate=#{time.iso8601}
      -X github.com/tensorchord/envd/pkg/version.version=#{version}
      -X github.com/tensorchord/envd/pkg/version.gitTag=v#{version}
      -X github.com/tensorchord/envd/pkg/version.gitCommit=#{tap.user}
      -X github.com/tensorchord/envd/pkg/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/envd"
    generate_completions_from_executable(bin/"envd", "completion", "--no-install", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/envd version --short")

    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    expected = /failed to list containers: (Cannot|permission denied while trying to) connect to the Docker daemon/
    assert_match expected, shell_output("#{bin}/envd env list 2>&1", 1)
  end
end
