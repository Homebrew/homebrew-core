class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.8.13.tar.gz"
  sha256 "1388002beecf3faa5e9a7998ec1d092f05d7ae98a05826959b2178a9c48ee910"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6162e9a50f31a367f16f351e1ea101bd7229c56d6818012ec1ac745237b92b5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39bb2b69a2e851b158da7f82c92ce81961c1d46c2d8819f3249871a7c26f7b3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c9c9734333abf64124c8778bcf0a519cf9558054635ee158d34cca2bb66704d"
    sha256 cellar: :any_skip_relocation, ventura:        "f843d29d507e23fe87401be65e172fd861b2319214171a1e34fb0facdf51c022"
    sha256 cellar: :any_skip_relocation, monterey:       "e7be50da19ff573e74d7856c132da0d5f073d7ab5a77a26dc5902a844681e40c"
    sha256 cellar: :any_skip_relocation, big_sur:        "038fe49667248c5f653ff96bdcb593b5632a4bcafb53fcd0a7542458f95759a9"
    sha256 cellar: :any_skip_relocation, catalina:       "c7a74d4490082221e477bf1585419013ad0c765ed6b07af48f2172422b5d4d26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3eccc3d5189b5a0ac52fa1fddde196f2d476a4e78076d4ba9ef2c992b41afdb2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_equal "", shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
