class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/2.8.4.tar.gz"
  sha256 "c40e88ad618c5afd88b2458e6a5e5d773345f52a90f970e95ca71b5fcc0740b1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a58c775c2d8f8e1b6847407131d31051bf069bf593d944c478c9422a367661d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a58c775c2d8f8e1b6847407131d31051bf069bf593d944c478c9422a367661d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a58c775c2d8f8e1b6847407131d31051bf069bf593d944c478c9422a367661d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "04ae22843cb3df97e831db8616de924067b10162224baecb974b0530190af5ec"
    sha256 cellar: :any_skip_relocation, ventura:       "04ae22843cb3df97e831db8616de924067b10162224baecb974b0530190af5ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ace041a1d4d2c98e98df5ac29b497c8d3e4edfd3ef2762b3fe296d26793ec56c"
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
    assert_match "Management tool for Kuma.", shell_output(bin/"kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
