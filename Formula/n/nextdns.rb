class Nextdns < Formula
  desc "CLI for NextDNS's DNS-over-HTTPS (DoH)"
  homepage "https://nextdns.io"
  url "https://github.com/nextdns/nextdns/archive/refs/tags/v1.47.1.tar.gz"
  sha256 "3356b283a8eeb675efee8163854c83c65d1dbb7743bac04db696751290f8ee64"
  license "MIT"
  head "https://github.com/nextdns/nextdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42b9ae4eab445ad25eadd9f211bee8e3933e17cf25057ae73c9ce2fba4927a90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1deb8eb5df9c2adca09b2370283fd0fb1b25479df9ee7e5a74519479bb9f1984"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5535b2daa84051caa7707687be529ba88adc23c178cd4788b2cf1abbff32b063"
    sha256 cellar: :any_skip_relocation, sonoma:        "334796163a459547e92494904446e807f6be8e914dd2326998f376fef0cbc5b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "049a091172de82955386167851938838c48ab61e57dc2b5ae89135a3e9b52589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3d3979d0fef14e2c70d334dfe867f5ca6ec4bc10ddc6262ab5564cfdf65d781"
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
    assert_match version.to_s, shell_output("#{bin}/nextdns version")

    # Requires root to start
    output = if OS.mac?
      "Error: permission denied"
    else
      "Error: service nextdns start: exit status 1: nextdns: unrecognized service"
    end
    assert_match output, shell_output("#{bin}/nextdns start 2>&1", 1)
  end
end
