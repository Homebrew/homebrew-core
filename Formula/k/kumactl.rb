class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/v2.12.5.tar.gz"
  sha256 "b7d27a10661a145cb2f0085cbc1be1e402d3d3628520b540d23564313925fcc6"
  license "Apache-2.0"
  head "https://github.com/kumahq/kuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4dd7aac12315a0f51ba563cbe1f9ef9828a7a3c6e86bce26582906e7742c70e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "325f16198a688406e3dd1cde477e35a48415e5c856130f94f39a4d5168c05f67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d3855b55131d2019b114b688219d1036dce5a72dab061c5becf81106fb51627"
    sha256 cellar: :any_skip_relocation, sonoma:        "96c99e1e045b992e726fc1bc6440ca8282df29ad8352f4d08bd69c9e6daf9725"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1aa86fd27519d58d064c81e64022f19dfd63c7323ff3c0cc70d9979021bf7b6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce2abee00f3a803b930c643f517cc636e74262346cf02f0f50e9f317695d8c15"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/v2/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/v2/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/v2/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", "completion")
  end

  test do
    assert_match "Management tool for Kuma.", shell_output(bin/"kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
