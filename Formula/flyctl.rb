class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.454",
      revision: "8c59e3dc591c6922d1db1cdc17f6e369126dbeba"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99978cef15b5a97a7b221000108875c415d32ff32dec0feffdf0e9c4f5176334"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "477b7e5a41522e7809e1531076da6864c567ae5d3c6b9fecf193dad74b59442b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f794e612a8455f9f1eeb1ccee373f51572d48efa8129e6c2b4d87c70040f250"
    sha256 cellar: :any_skip_relocation, ventura:        "7d0ede9b6f11fbbada766253619d73e40fd8ce9ce08f610788ffec9f0de97fec"
    sha256 cellar: :any_skip_relocation, monterey:       "e0fbb8d6603e4cc946de0daeea8b9e9a4f0ad5cc042c59fe6179f6e4a06183f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "4950788615e57bf957ca3070ee73d8372fc2d6a01d4641bee6e9f550d031694c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88b81dd6e2577563dd90462ad74261553d049fcb8ed9fa2d734a0b8fc90e65f4"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.environment=production
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.version=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
