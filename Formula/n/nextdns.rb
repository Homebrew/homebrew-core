class Nextdns < Formula
  desc "CLI for NextDNS's DNS-over-HTTPS (DoH)"
  homepage "https://nextdns.io"
  url "https://github.com/nextdns/nextdns/archive/refs/tags/v1.44.3.tar.gz"
  sha256 "ac77f24eb0bded216b57a82ca93960547c07561080df3fc20d1b363e38b7f3af"
  license "MIT"
  head "https://github.com/nextdns/nextdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0685ea4c5cb55563548f3c94bce4c7e4cf0582f8d85ef494bc77c6e7aaaa54d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5ccb2c00b8fe08cdb03294fdd53e00222fc29c4b2c5f3d6475ae562dcbe0071"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "909ba619d29f604a6d6cbe48251db4c4ce0f2864d281a9cbdc629070fcbb6637"
    sha256 cellar: :any_skip_relocation, sonoma:        "649735a69c513fcb0187fcf4ffb86d0b97ff0f873a905d4475ab1c83d08d69ef"
    sha256 cellar: :any_skip_relocation, ventura:       "adfa3676d6a880a0adade9ae4f90ef15ac8fb5d37ad42b8cf4a274a1114113c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4911d99e1ab572c7bb0e26d14f6b0ceb2fafea634b4f81996d098ccda1b901a4"
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
