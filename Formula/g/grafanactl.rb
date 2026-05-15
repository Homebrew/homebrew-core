class Grafanactl < Formula
  desc "CLI to interact with Grafana"
  homepage "https://grafana.github.io/grafanactl/"
  url "https://github.com/grafana/grafanactl/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "c3a3fef02f073aa92fb7b62c6f60a26e80fe794cf158f86830fe38ff053035fd"
  license "Apache-2.0"
  head "https://github.com/grafana/grafanactl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8681101d7ce09ad2f0bbe19bac3729a733a9005aaa5e6a4fdd57a555f8c130c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8681101d7ce09ad2f0bbe19bac3729a733a9005aaa5e6a4fdd57a555f8c130c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8681101d7ce09ad2f0bbe19bac3729a733a9005aaa5e6a4fdd57a555f8c130c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b44a3bb495b05b91c124983e899a6e76573eecd61bade09bace5289255840d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8fda68f21b5faafbbacaad8faa63435180d0c95f3a011f0e625fded17b28a5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9aee39b653aaf1f4c2f58598eacac6f71dcb2cdc3f7a52f5f4948bbe30e87209"
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
