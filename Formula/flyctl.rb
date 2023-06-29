class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.43",
      revision: "962df6a268b88b4e49017bde49be31f9c079ecdf"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "080129db4a2441b8a458cc4674cc9f54eafe6ed756c36c224cc26abe2403c80b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "080129db4a2441b8a458cc4674cc9f54eafe6ed756c36c224cc26abe2403c80b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "080129db4a2441b8a458cc4674cc9f54eafe6ed756c36c224cc26abe2403c80b"
    sha256 cellar: :any_skip_relocation, ventura:        "49f8e4258e0441354b1965f2724ed0603fecb56a2b8f4ed611ae85aed765f460"
    sha256 cellar: :any_skip_relocation, monterey:       "49f8e4258e0441354b1965f2724ed0603fecb56a2b8f4ed611ae85aed765f460"
    sha256 cellar: :any_skip_relocation, big_sur:        "49f8e4258e0441354b1965f2724ed0603fecb56a2b8f4ed611ae85aed765f460"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "feb29329b91d56b59687436c9c99022fe959aea9a5befcdde01672a0bd23d381"
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
