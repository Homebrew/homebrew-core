class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.115.0.tar.gz"
  sha256 "ca752eb323f973f7e987d5a51e0d5427d753e4376873bd81c23889d6321b231a"
  license "Apache-2.0"

  livecheck do
    formula "ghz"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfdfa6fd806e5bb37bac3afac2dfee4e44cbf62795eff4bea5811c830a726d60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e1ecc9270c6c0ae41c4c399a66a3027d8de903471e9982a0a0a8e585898378c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73210d7786f6c8270b27c555f3d5486166d529abc46c261506af4c4e4a6ec72e"
    sha256 cellar: :any_skip_relocation, ventura:        "e610d6b15f2425b65121bfb17234b6e7e30456cc3b09d3869f58150ddf0756b4"
    sha256 cellar: :any_skip_relocation, monterey:       "569b999a1c359a7ef0614fdd46b570b0f0f9bf550df23a8380dad9332c15c3aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "fec4f34fbfaca70dab721bf9d8c0245c2e1030a2d19650112245a2ec83c9c9e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ca7c5e2534062f9e1aa849c7c8ee36fc00922da080a453bb1ffbf28fec99227"
  end

  depends_on "go" => :build
  depends_on xcode: :build

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "cmd/ghz-web/main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghz-web -v 2>&1")
    port = free_port
    ENV["GHZ_SERVER_PORT"] = port.to_s
    fork do
      exec "#{bin}/ghz-web"
    end
    sleep 1
    cmd = "curl -sIm3 -XGET http://localhost:#{port}/"
    assert_match "200 OK", shell_output(cmd)
  end
end
