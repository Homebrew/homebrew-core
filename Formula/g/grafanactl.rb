class Grafanactl < Formula
  desc "CLI to interact with Grafana"
  homepage "https://grafana.github.io/grafanactl/"
  url "https://github.com/grafana/grafanactl/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "f978c3f36d6b6efb1e145a73c9f3fdeca1720def348a137fec6a289fb7df4541"
  license "Apache-2.0"
  head "https://github.com/grafana/grafanactl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d1be923a9df9276a27f9e4965647e811a1873358209703187fd639657327388"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d1be923a9df9276a27f9e4965647e811a1873358209703187fd639657327388"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d1be923a9df9276a27f9e4965647e811a1873358209703187fd639657327388"
    sha256 cellar: :any_skip_relocation, sonoma:        "39da9d2b1a823939683d3a4e2a4d97f14ccebc44de736e5f2048c0992d44d1e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5a8960cacedff76439080b8aa593b4fb0101cb81f9ef5808aa1ca7d43d5c3ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81f3d8fde16bc8c3f2413f94ce0e29887fc5dc25526c717d798e28d9eeb1805a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grafanactl"

    generate_completions_from_executable(bin/"grafanactl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/grafanactl --version").strip
    assert_match "current-context: default", shell_output("#{bin}/grafanactl config view")
  end
end
