class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/2.0.2.tar.gz"
  sha256 "c8e14e190122f261420f2c27783527f5cf74a6faf85530197874fdac3f68d235"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e14008c416ade9db640e0e9bfabfc5a3c20c15087e8a715d668418bf6d47c838"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16bd0223de49d22b7b54a794999bc569debaf58d54f596851419106c8a56c6a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f0d5b990849944508a65aa6ef911415929a4d1c15dd27251299d8e98bb669f1"
    sha256 cellar: :any_skip_relocation, ventura:        "f6e9a500142abfaba0b0a601b0b8a39395f0a0b6653d5c9869cfc13b387b7357"
    sha256 cellar: :any_skip_relocation, monterey:       "c14e4ac73bb5d6e5929ad7916b3756fab8665954fdbc204b53ab99e86776b1b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "09d84200916201dd16fde96e9e0a7d8d778958f33bdbce698f5a1cb23bbddbc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6b34fe1267919190befaeb34df99d7d3abc549411be8e2d2aee72270d2b5d37"
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
