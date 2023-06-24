class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/2.3.0.tar.gz"
  sha256 "893bd6d6e5d70101a8e42e72fdba448e02b6e773a21a32ccdc9a13fdf0ba9e58"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70599342640579a5203157aca352ba27e21634a99aa28a0fb493c88ea9fb8bee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70599342640579a5203157aca352ba27e21634a99aa28a0fb493c88ea9fb8bee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70599342640579a5203157aca352ba27e21634a99aa28a0fb493c88ea9fb8bee"
    sha256 cellar: :any_skip_relocation, ventura:        "4a61f97e57d6b05b94172a82ae004f2159c66d8b7553ccac22dbaeae81ae2064"
    sha256 cellar: :any_skip_relocation, monterey:       "4a61f97e57d6b05b94172a82ae004f2159c66d8b7553ccac22dbaeae81ae2064"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a61f97e57d6b05b94172a82ae004f2159c66d8b7553ccac22dbaeae81ae2064"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4ceff757c623cdf05b118d3256bbe83529a47ba412555b990dd3311facb04ff"
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
