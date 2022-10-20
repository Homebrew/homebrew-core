class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.8.1.tar.gz"
  sha256 "ceb22fa7d3b5a56a6f963b6306c7224211ec957cd11544c2cf7408f26718bea2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0c89ba0e9bac60333f46e009f41bb809fed718e3b39de5b8101a6a225c83ed5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe4657d043ec6823b748ed465c470a9964fd0729a4d84e5e592276798c140520"
    sha256 cellar: :any_skip_relocation, monterey:       "5a662fda1c59cce5bfc9605a6248f245a9cfaecef27ecd053d5ebd5e13ebabf7"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a50ebe11045edf7d90ad96c682f3a8048092640130af29c260809e5dee0ef2e"
    sha256 cellar: :any_skip_relocation, catalina:       "ccfe95c2fc4123603539660370f89676c8d0d33f31ffec984c27b891493d04e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a6fc75e1e41fb418b5f223820c8fe666b0e28f1bca5936deabfbd5c479112b2"
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
