class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.7.1.tar.gz"
  sha256 "042e3e28e26042f416949c04ecca595291605746a700cf6e82957094dba9aca2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b312eec84a89cbd47c3682082ec0539e4e2fa7ecfb50c13f8d7cf573436d218"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73a226f5864e8e6dcb18db989edf344025ea4322e0cf406cf1b7bd73b341f71c"
    sha256 cellar: :any_skip_relocation, monterey:       "8a2ca244d7af918cad7d3624c832de398c6d38a6ea1d2db72ac947aa2b8b26d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "403d23e84e307f16a3862b5c3e2a7646421edb34f1031b1184ae23f4e03c1aff"
    sha256 cellar: :any_skip_relocation, catalina:       "12289d4e5d755ae22647376974aa9f25b60976c59ae0fb8bea187148f767cad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f52ff66b2f8bf89d4efc10f5edd18ed76d6c538ee6a18a7b80edd5a8bfb0991"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/pkg/version.buildDate=#{time.strftime("%F")}
    ]

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
