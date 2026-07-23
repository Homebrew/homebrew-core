class Dockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/jwilder/dockerize"
  url "https://github.com/jwilder/dockerize/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "1e5b0dfe177d96574f43d03057572d853a3d11f64c46eebd01a7e9434ad933b1"
  license "MIT"
  head "https://github.com/jwilder/dockerize.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb7664884e286907024b0442d642bfe3eb9779810b06d20bc97c24d888049dcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb7664884e286907024b0442d642bfe3eb9779810b06d20bc97c24d888049dcc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb7664884e286907024b0442d642bfe3eb9779810b06d20bc97c24d888049dcc"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f1f422d9b0ccf94052bfea259e9671975d40655350ca4e274c149ddf6ceb1d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fec1e0ddbfb6824e17d2d8f6bff5c5baf2fd86c3e3530015dff63c251c359f2f"
    sha256 cellar: :any,                 x86_64_linux:  "971b610f4fd5e7e61fa2364f588b4a552cb058d0fe33f0ccf940691c01e0b914"
  end

  depends_on "go" => :build
  conflicts_with "powerman-dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.buildVersion=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
