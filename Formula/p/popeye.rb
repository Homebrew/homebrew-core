class Popeye < Formula
  desc "Kubernetes cluster resource sanitizer"
  homepage "https://popeyecli.io"
  url "https://github.com/derailed/popeye/archive/refs/tags/v0.21.6.tar.gz"
  sha256 "b2fdf6f8741afe05363b43b081be4eb1283e18d293f1906ec5a59b3993fa82d9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a64f005e303926b5efdad43ce2dc764c57943634088c92f02525b98def778fa3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9dc0cc0f24506a5d30e3b237dd33f127f163b1b1abb2d5af2d8305219f43874"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "22a37ef3c1e3f2c4f1004d52b80f73e1025d3714aaf6264a7d3cdd46509d07fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6a5410648d6a8f7067b9b8dcf1d704efd4906585dd2c2d5c418408adebe892f"
    sha256 cellar: :any_skip_relocation, ventura:       "4ecc6ec98b8e985dae5170e51baafb3d5775b10a594250a31bb91edb3df0d3aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d7d3eb07436d7b42569e09df6058de3acb9b2e5a49fe59bd46c1701495dcf47"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/popeye/cmd.version=#{version}
      -X github.com/derailed/popeye/cmd.commit=#{tap.user}
      -X github.com/derailed/popeye/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"popeye", "completion")
  end

  test do
    output = shell_output("#{bin}/popeye --save --out html --output-file report.html 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/popeye version")
  end
end
