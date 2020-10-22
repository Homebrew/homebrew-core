class Dnsping < Formula
  desc "Like ping but for DNS servers: checks latency and errors and report statistics"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/dnsping.git",
      tag:      "v1.1.0",
      revision: "94b2d9a27df3209e5b39594bf3d000dd865748d1"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "make", "official-build", "OFFICIAL_BIN=#{bin}/dnsping"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dnsping version")
    output = shell_output("#{bin}/dnsping -c 1 www.google.com 8.8.8.8")
    assert_match /^# target/, output.lines.last
  end
end
