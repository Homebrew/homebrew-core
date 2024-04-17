class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/2.6.5.tar.gz"
  sha256 "52c5e9b54c4e6ee2e3f42d73eb1dec06a21ef92022f64dc86f9762cdb9d64e03"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d06392c934c0d3ee3f75e368607b3924360093eb8e8bbd89bc4ae66569c22334"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c2fa0ad80ed02523458d901e3e4a96e074cf73406e53236d4579b27755d806b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd171db209f99bb644fd0a3b09cedafe682afd9dcc373602453709dfc8da8c2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "3771f8e803ceaec9abc82317de309350f1f0fd37f2d6b87f1948df8008d0ad32"
    sha256 cellar: :any_skip_relocation, ventura:        "052531b0afbbdbec1a59e0975ec0c232986d054c63244f7d96df44757114d1e4"
    sha256 cellar: :any_skip_relocation, monterey:       "85c5c09c852700671fe534c20dcc1ca2a5b8a94d40855d972735b788b1ed92d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "718b7f00ed87948445fd8cea57b6a2323ddbfc8e6ff269b4bd3afbf2b6b55ef7"
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
    assert_match "Management tool for Kuma.", shell_output("#{bin}/kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
