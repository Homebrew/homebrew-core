class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.8.17.tar.gz"
  sha256 "9f59e730186fe02405c22547bfbd5d89b08641524f8aac673a0cc2d9e83b0f27"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d72660a81966cc84eda5f9793932975f4f9e2c3e967d14e46e55cf02cd872964"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19ce77f0eaf84661329f57c49cad985390d0c853317aa5922f33ca32f39f80eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ca6c3eb0a49e9ee580f820ac7cf5be9f7085e9af950056e691b950c0d8752f2"
    sha256 cellar: :any_skip_relocation, ventura:        "d5f1dd426fe65d72cc5cd09cd81aaae2fcf815465882dabd30ede83da258d18f"
    sha256 cellar: :any_skip_relocation, monterey:       "038316af06b7a2d3a89a47f3023dfa0f0978b7d3eaf6f3888f46d3e1c2695250"
    sha256 cellar: :any_skip_relocation, big_sur:        "d726d1f9e8857b75325e60e50148be5f8e2cb4991eb7b21cb30fedd531e578fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf855ca03bc8b9da0d2ded35d44fbb844c4a6eebc0e693a6eadf1f8771009caa"
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
