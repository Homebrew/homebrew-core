class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.3.1.tar.gz"
  sha256 "bfd8c6c0d0b8b463f1ad93aa346297f3ed2455bbaa8e89a8b8a72ce653a7e287"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3a1c6c1573c3235889e76e3f3b1ab8305da6ecac6d620d9059a73da40a047fc6"
    sha256 cellar: :any_skip_relocation, big_sur:       "38b2fc7ef7e2e6e6f499dfa3be1c71477b19a61337a3cb2e46dc57da962ae28f"
    sha256 cellar: :any_skip_relocation, catalina:      "389495b046a52b50adf6f9ff8a6c5d5e869d159e68ce59c692d8323f9585dd8c"
    sha256 cellar: :any_skip_relocation, mojave:        "5ae1534a6dce03cd5b136b0897e67d99b4900c9048a64f80fbe5f6fdb35578b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc55032e0454eac8726f383efa394624937cf9a00fa44f586ba57c8831069b8d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/pkg/version.buildDate=#{time.strftime("%F")}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags), "./app/kumactl"

    output = Utils.safe_popen_read("#{bin}/kumactl", "completion", "bash")
    (bash_completion/"kumactl").write output

    output = Utils.safe_popen_read("#{bin}/kumactl", "completion", "zsh")
    (zsh_completion/"_kumactl").write output

    output = Utils.safe_popen_read("#{bin}/kumactl", "completion", "fish")
    (fish_completion/"kumactl.fish").write output
  end

  test do
    assert_match "Management tool for Kuma.", shell_output("#{bin}/kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
