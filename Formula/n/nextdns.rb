class Nextdns < Formula
  desc "CLI for NextDNS's DNS-over-HTTPS (DoH)"
  homepage "https://nextdns.io"
  url "https://github.com/nextdns/nextdns/archive/refs/tags/v1.43.3.tar.gz"
  sha256 "574b377d6f4af140e3dcfba78fcf68d52ddb32390c020d1fe9bc5ade0af85f97"
  license "MIT"
  head "https://github.com/nextdns/nextdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5ecd2983e97caa5ca4169d8bfa8b828ff198526a68bf4429ed71bd9f357c9d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97c80dc13dd3787e12d626af50a867ee98793fbc7911e4536175e9d3ae0b7720"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8abc16e9f911140fba6497c344818f20bde9feff58e7af41e7c9d5c2697f43a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "4dfc3e6e7fa9eee75a13096a80978ae60d3ade46333582b971ed5ef3c5c8315b"
    sha256 cellar: :any_skip_relocation, ventura:        "fde6b2c87d02bc7eca523bd1fd0788adf7d836e0d5a1bea49357c692f543ba2a"
    sha256 cellar: :any_skip_relocation, monterey:       "625754587ce0fb8a759e19c9ac3fd4f21dd199325beaf8e405dd1ec2a8f48b81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e487514277c9d5d09dae3788c0b0f5cd54f629bb822ec72b1c0987568c3bbd1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output(bin/"nextdns version")

    # Requires root to start
    output = if OS.mac?
      "Error: permission denied"
    else
      "Error: service nextdns start: exit status 1: nextdns: unrecognized service"
    end
    assert_match output, shell_output(bin/"nextdns start 2>&1", 1)
  end
end
