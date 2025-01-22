class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/2.9.3.tar.gz"
  sha256 "27a49c417bf16ad38e1b74fc93926a5bdb4b6241cde2c6c4f80ccb54217511d6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a559f879264573d109ec5de320e1f0e2c9dadb705d249f7b83de416e9e99967"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a559f879264573d109ec5de320e1f0e2c9dadb705d249f7b83de416e9e99967"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a559f879264573d109ec5de320e1f0e2c9dadb705d249f7b83de416e9e99967"
    sha256 cellar: :any_skip_relocation, sonoma:        "912bd6dab235d60a3ed5dae6ba9fee14f92925577ed7ba281f96adc8967cbb3a"
    sha256 cellar: :any_skip_relocation, ventura:       "912bd6dab235d60a3ed5dae6ba9fee14f92925577ed7ba281f96adc8967cbb3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43c02bf391e7ecf65d8aca47fb906c0378adf55a06b15a2e2e089fce59fcaacd"
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
