class Ali < Formula
  desc "Generate HTTP load and plot the results in real-time"
  homepage "https://github.com/nakabonne/ali"
  url "https://github.com/nakabonne/ali/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "faf94ef7e0daa6d51b7064dd9757d4216168b19ed03c145ebf30e18f99fc81ad"
  license "MIT"
  head "https://github.com/nakabonne/ali.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "624cc8b3f6325523929329a805679aa2673e4661be3a1fce71e01e0e44b6b50a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "624cc8b3f6325523929329a805679aa2673e4661be3a1fce71e01e0e44b6b50a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "624cc8b3f6325523929329a805679aa2673e4661be3a1fce71e01e0e44b6b50a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1da05b48801e6f5c3a531247c8324d4a64511163160cfc13fdf04d1563bff29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "863149c4dcf2dae9d28782408691036e9ff7751d35a1972269c2e23e699a173a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7432b8c57f6c2b8db945d82dcc6904496eb17424e7de280cd01ef7339d731b72"
  end

  depends_on "go" => :build

  conflicts_with "nmh", because: "both install `ali` binaries"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit= -X main.date=#{time.iso8601}}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/ali --duration=10m --rate=100 http://host.xz 2>&1", 1)
    assert_match "failed to start application: failed to generate terminal interface", output

    assert_match version.to_s, shell_output("#{bin}/ali --version 2>&1")
  end
end
