class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/2.6.0.tar.gz"
  sha256 "5fa180d5773f8a5916205fa12f36a9cf45ab723453690247942b6e843a244e9b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7dd1fb4798f03f1a525a45808ca369e6d3bc837f0e38b0586d927fc5d88921a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35ca1ea53fb87687c577c4761ac2b0ffc7dc27a7e8ff0f03d14f60d8b24ea091"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ebeed8f00abe8d67ec8868a689730730cf3f4dae89cf9c498b0bf0fee3d9a32"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e5e657931a90127bbbfd15ae644a1bf6aa5a746bf68b0ed667e540288985a9a"
    sha256 cellar: :any_skip_relocation, ventura:        "a06fcf583e0d69b77e80df5ff9ec751d0d586bacd3a783de1565cd72c0493641"
    sha256 cellar: :any_skip_relocation, monterey:       "1c2b25fd840e1cfc476b7697504c03c102826c83b6bcce7ef69d51c64872c7d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea956ab57118766e1f24eee26cbb1f533020a466d9aec0224fb66ac29d5c431d"
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
