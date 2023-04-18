class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "d52f90409e1e85555511a54057d228ae92e3f66cd613decdc276afbe1a8e541c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "947b9d3b4f39446f4eeebfc4e7c6330b7e41f043d2cc9be42ef83a8772f9c3ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "947b9d3b4f39446f4eeebfc4e7c6330b7e41f043d2cc9be42ef83a8772f9c3ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01572f20638c723800da1f06d73867af1b8435ece6cf5d6d69ec00c143fc6891"
    sha256 cellar: :any_skip_relocation, ventura:        "6e38e0753c809d1ba050e7c74986fd217fcd9f3c96fd2d23c40961842d8bde0c"
    sha256 cellar: :any_skip_relocation, monterey:       "f5af5cd1bec75ca7393883d9f6155e6840c84f5cf8dee98db53a2783cd18bbfa"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e38e0753c809d1ba050e7c74986fd217fcd9f3c96fd2d23c40961842d8bde0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcf1ddcfd2fbd9f62cbac145cb3773c8250761f075b12c24ec7ede68d3ee6f58"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/liqotech/liqo/pkg/liqoctl/version.liqoctlVersion=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/liqoctl"

    generate_completions_from_executable(bin/"liqoctl", "completion")
  end

  test do
    run_output = shell_output("#{bin}/liqoctl 2>&1")
    assert_match "liqoctl is a CLI tool to install and manage Liqo.", run_output
    assert_match version.to_s, shell_output("#{bin}/liqoctl version --client")
  end
end
