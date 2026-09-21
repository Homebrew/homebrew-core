class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/v2.14.5.tar.gz"
  sha256 "56cdecc20c8c95b53c37656c2bd19dbd807f98fb995360ee271b0bdecd8f2aef"
  license "Apache-2.0"
  head "https://github.com/kumahq/kuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "94df930427857df2e9af883ad8601c8121d055926b44224b8c5b84f665f2d683"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "47672a3a38e789b76d59d5a852940b52ca9d8987615e3a98c34deb60929cc68a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "82d5f3438bf255c12d2bd26962d22348465993ebd32077355a80c88654b9379e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "688bdda9672f96d2ace62ac4e85175de1cf8162e9fb0283d7479d82565915fd8"
    sha256 cellar: :any,                 x86_64_linux:      "5b907d1909f66ebccb05cb90328c043ba57e9ff8441e3a93fbc7a45568cf975e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/kumahq/kuma/v2/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/v2/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/v2/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Management tool for Kuma.", shell_output(bin/"kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
