class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.399",
      revision: "3f98b0dd093a573565c60b9f41d533bd74f7d54d"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67bccf37772a0edb2870b67fcbab35eb62d3bfb07739b02f7897f3119d07d74c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67bccf37772a0edb2870b67fcbab35eb62d3bfb07739b02f7897f3119d07d74c"
    sha256 cellar: :any_skip_relocation, monterey:       "6a9804c3e6559d0d7a32339b7c18808844215f9c171eba71f18b8f1c31996281"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a9804c3e6559d0d7a32339b7c18808844215f9c171eba71f18b8f1c31996281"
    sha256 cellar: :any_skip_relocation, catalina:       "6a9804c3e6559d0d7a32339b7c18808844215f9c171eba71f18b8f1c31996281"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48652f1905c5017f415db431551820e980264ab2c22bace41e5f7a8996ed278b"
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

    flyctl_status = shell_output("flyctl status 2>&1", 1)
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
