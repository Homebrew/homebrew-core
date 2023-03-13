class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.485",
      revision: "5865fc37cfa12d4d2195093d084835ee4a5d4b8d"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b920df19ab0c011ad77d1887b509dc9b26d1a478e432f1001828b7779d02336d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b920df19ab0c011ad77d1887b509dc9b26d1a478e432f1001828b7779d02336d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b920df19ab0c011ad77d1887b509dc9b26d1a478e432f1001828b7779d02336d"
    sha256 cellar: :any_skip_relocation, ventura:        "f21d5af1be766710c3be57af5b06b588afb66479e98d94277c53a560c7cd4222"
    sha256 cellar: :any_skip_relocation, monterey:       "f21d5af1be766710c3be57af5b06b588afb66479e98d94277c53a560c7cd4222"
    sha256 cellar: :any_skip_relocation, big_sur:        "f21d5af1be766710c3be57af5b06b588afb66479e98d94277c53a560c7cd4222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "687ee0b7299e4057ea39011f7950cb684a853c9f07dd5ff70179a29de9c40ade"
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
