class Cidr < Formula
  desc "CLI to perform various actions on CIDR ranges"
  homepage "https://github.com/bschaatsbergen/cidr"
  url "https://github.com/bschaatsbergen/cidr/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "caa803f91b634bfa955c4898abf3085b83c5c3cbcd56f81cc64f29510a99f707"
  license "MIT"
  head "https://github.com/bschaatsbergen/cidr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcbc8cd8981394e22863784293723d4f498d4e99e7bd887303f627fd8800bcd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcbc8cd8981394e22863784293723d4f498d4e99e7bd887303f627fd8800bcd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcbc8cd8981394e22863784293723d4f498d4e99e7bd887303f627fd8800bcd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "69746c5df310b241ba471f7007baa62bd134d3b29e9ad6f84a0ae4b57a8a043b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbc02e2c488fce47f5d8c777a0bb2691fc83f671bd8f3fa38fef07042e99ac7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88883882ac33253f400a15c6e38dccb0d502bef37985da5f0f3af8e0d3be53a5"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
      -X github.com/bschaatsbergen/cidr/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cidr --version")
    assert_equal "65536\n", shell_output("#{bin}/cidr count 10.0.0.0/16")
    assert_equal "1\n", shell_output("#{bin}/cidr count 10.0.0.0/32")
    assert_equal "false\n", shell_output("#{bin}/cidr overlaps 10.106.147.0/24 10.106.149.0/23")
  end
end
