class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.7.0.tar.gz"
  sha256 "6c62b9f8d34c53cd3eb92914e5828ed9a4036251c8d812c47fcdbdcf56fc4aa8"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1737f54d79bb9b13f129d467e629e8dbd3d48767f08695df57a3862b3c1a225"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a46df0ed8dcb4bc791245bd6d98a42c6d3baac74990e7d45d26eddf4ff012d11"
    sha256 cellar: :any_skip_relocation, monterey:       "0cbd339e275645f07407567f23d1425921bb1db9f397ae3fa4bf39f8ffe549bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "6bf0f70c291bde3d0f62acbfd4e230ca8307daaa1242fb4eecfd268005b35982"
    sha256 cellar: :any_skip_relocation, catalina:       "9495203eba813725b643798cd04adb7f78282f82d1fc59b5b8e8d70faa307239"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1aaa59c7e5b3592d2c15c47664c2ba87d2c0e3f61e53666835fa47fdb7a758bf"
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
