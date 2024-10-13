class Nextdns < Formula
  desc "CLI for NextDNS's DNS-over-HTTPS (DoH)"
  homepage "https://nextdns.io"
  url "https://github.com/nextdns/nextdns/archive/refs/tags/v1.43.5.tar.gz"
  sha256 "743f64d876c2c7afdae47716af1d41a6c5ec21adae74a318e5eb9319023a38c2"
  license "MIT"
  head "https://github.com/nextdns/nextdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "92db43f128cccb0d1877b6b9138ac1152f798d3b1001c73595860f632ce17770"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "84c5f6aea03060da28c575ada2a8a0dfbd9b24a17c9a9866907946d43931b010"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d75dbc158e5cd0805c938c49b8e81f1ee8adb71e54e3ea63d4a104eb91e6a1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04fbd90d61c253e536942657dbc067b856eea479d095334b589911ecc71636a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e0719adba9859b2e620feb4e30243cea09477dac912d101a40c3db8888241a6"
    sha256 cellar: :any_skip_relocation, ventura:        "dc86cd070f7364748641a3a4301dd57e5a19d8b7bb036fcf909fa4aaf97c98a6"
    sha256 cellar: :any_skip_relocation, monterey:       "208223fa6193735d453fef9a49e8b2c7c02990ced228c561366883872c5dc3b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de3f5666921a4842bc4ee14544adf63f2baa789fa3cf21ceae805ec4422e7b9d"
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
