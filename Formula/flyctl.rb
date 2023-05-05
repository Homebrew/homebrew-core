class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.556",
      revision: "9b6147f2df7703f06409b38980a3c5a08ccd8248"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a555c9163494aa25ce8e4e98e21921dc103f1d0704c6eecbde8cddc8fb140eba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a555c9163494aa25ce8e4e98e21921dc103f1d0704c6eecbde8cddc8fb140eba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a555c9163494aa25ce8e4e98e21921dc103f1d0704c6eecbde8cddc8fb140eba"
    sha256 cellar: :any_skip_relocation, ventura:        "c2fd6404f040f9ff32c7dade65352fef7528b6e2473d8f5e3484b383dd2d819d"
    sha256 cellar: :any_skip_relocation, monterey:       "c2fd6404f040f9ff32c7dade65352fef7528b6e2473d8f5e3484b383dd2d819d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2fd6404f040f9ff32c7dade65352fef7528b6e2473d8f5e3484b383dd2d819d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b96c1b2a0b31ea30e34aa5161455e5c85d61b8bed0bd72664ef9f100522c18ef"
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
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
