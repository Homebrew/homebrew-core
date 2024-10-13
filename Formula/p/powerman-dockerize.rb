class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://github.com/powerman/dockerize/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "7ae6ed0389419ceef9a942e6bf33b5b6ac787b420e0731b09fba41397bfe2e0f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b320bc5c69164a66bfcd303e6aa1f3f687ef857e6c012d8cd5fff199b1897cf8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5cf9d95f93951910dff994ca4cc17e2c6d1d190b7ae4667115e98f88edd7aa2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5cf9d95f93951910dff994ca4cc17e2c6d1d190b7ae4667115e98f88edd7aa2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5cf9d95f93951910dff994ca4cc17e2c6d1d190b7ae4667115e98f88edd7aa2"
    sha256 cellar: :any_skip_relocation, sonoma:         "ffeb190c33c4d3764af99d706c0a2efe1bf1eddeccaef476eebc660c1447c215"
    sha256 cellar: :any_skip_relocation, ventura:        "ffeb190c33c4d3764af99d706c0a2efe1bf1eddeccaef476eebc660c1447c215"
    sha256 cellar: :any_skip_relocation, monterey:       "ffeb190c33c4d3764af99d706c0a2efe1bf1eddeccaef476eebc660c1447c215"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee3cc921ecfb75d746a9db61a20b5cd6c0be7853e943a3024e688274de78ed3c"
  end

  depends_on "go" => :build
  conflicts_with "dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(output: bin/"dockerize", ldflags: "-s -w -X main.ver=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
