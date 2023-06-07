class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/2.2.1.tar.gz"
  sha256 "d0ecce898a8b5ce4edc2f475430e6c69aea87566faf86d5087dab24de55bf69e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f50664835eb00c4f90e338c12d3b984a4b40bb6a8210c99c4b9d37697cf26610"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f50664835eb00c4f90e338c12d3b984a4b40bb6a8210c99c4b9d37697cf26610"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f50664835eb00c4f90e338c12d3b984a4b40bb6a8210c99c4b9d37697cf26610"
    sha256 cellar: :any_skip_relocation, ventura:        "84b6da775d5ed3558b18b16f491507b719b2b0525fb4be6a89723c9781fe5cdc"
    sha256 cellar: :any_skip_relocation, monterey:       "84b6da775d5ed3558b18b16f491507b719b2b0525fb4be6a89723c9781fe5cdc"
    sha256 cellar: :any_skip_relocation, big_sur:        "84b6da775d5ed3558b18b16f491507b719b2b0525fb4be6a89723c9781fe5cdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d3f0a523aba55bf2e250b2ba281c42f7b9260f6b242c9fa3b4663e333e11484"
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
