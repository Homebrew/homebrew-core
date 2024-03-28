class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/2.6.2.tar.gz"
  sha256 "9b2aaca40d750f66b2919d66214e07fe1db5fa28874fc47f1034c88c0ed55c0a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec65c77bb7a2b5c4ff354697082162c8a61d3521097e603cd9ae5b3552608eab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b10d91898e1c6f99f14bae947a48166991b003f07331eee53dcc55e48c52310"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d30d71afa9f9e9462408cd1ae32c82bdbed494349862af158803e4b51ca12579"
    sha256 cellar: :any_skip_relocation, sonoma:         "393ef047d345a39a62e59a9d9fa0f287c2be05bf63a34d162858663426a269da"
    sha256 cellar: :any_skip_relocation, ventura:        "a94b529dd25c4cd3b798347d81cbef88689bac7aef39940367f210502d8ae07d"
    sha256 cellar: :any_skip_relocation, monterey:       "cd3da548ce9252f641a24ab3ba933939ec2cc5d4989e2788480b1f3577804bb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d12b26e152d3b1e4fb4cb28438215cde6e3045a69507310b2b39a6badc60a1c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", "completion")
  end

  test do
    assert_match "Management tool for Kuma.", shell_output("#{bin}/kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
