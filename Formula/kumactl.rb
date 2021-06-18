class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.2.0.tar.gz"
  sha256 "898410d11d6b905bf010832a02b6b16bfe94e57205be736188130329404e6fb2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4097fa948ca7e4ade21154b3a3fab634fa6246e660fd43e17f394884d01f1510"
    sha256 cellar: :any_skip_relocation, big_sur:       "280fcc2a498ef63eb8c7819b837c85e7886b99400687a2daa386eae4ae074122"
    sha256 cellar: :any_skip_relocation, catalina:      "a4d492b6a3bcdf9dd545f55535769674f1bfd321ba38a9579841da1f2cfee0c0"
    sha256 cellar: :any_skip_relocation, mojave:        "01c86cf43ef4a8b37f5f7ec4dd2c1db96f87f48908a07315092e26074f83c4b3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/pkg/version.buildDate=#{Date.today}
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
