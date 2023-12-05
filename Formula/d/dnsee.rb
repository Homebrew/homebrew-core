class Dnsee < Formula
  desc "See DNS configurations quickly"
  homepage "https://github.com/bschaatsbergen/dnsee"
  url "https://github.com/bschaatsbergen/dnsee/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "3cb698e4b560984332619384173ac72911a3b8280a19e3ccf7950a820df6c8d0"
  license "MIT"
  head "https://github.com/bschaatsbergen/dnsee.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/bschaatsbergen/dnsee/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dnsee --version")
    output = shell_output("#{bin}/dnsee example.com -q A")
    assert_match(/A	example.com./, output)
  end
end
