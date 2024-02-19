class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "b239c8207dd2f1c3c55b35bbcc2f85106c7dfd87f6eb1398b7db5d203dd6a839"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c3cfaa8ee1ee098912de541fe65871adf6e813d3001d4a7eeeffb0c757daa58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b904858c77df9fd9d252e3b001aeb9ef07f073ca2a99202abfa70886718f4226"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "926506854cb0949dc917966e2222fb7ea92d2de9d913da3822b7134d36b4ad43"
    sha256 cellar: :any_skip_relocation, sonoma:         "c520db531148b3280619030669c5f2dc7b8a3adfdc69ab348b25fb26efd0e51f"
    sha256 cellar: :any_skip_relocation, ventura:        "ab4dcf53e31cb6f5af5f20f0c900427dd095666321bcfbbca01e6742ecd78a6c"
    sha256 cellar: :any_skip_relocation, monterey:       "c93b3ffd1b02efecb83d319b3edff0d38584d85d873fb038efdbe517d2d90d71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6766838b2ffa2fb89076abc3d6950f2f48e6b3a550eb7690a5eefc80af808658"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./core/cmd/hoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}/hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}/hoverfly -version")
  end
end
