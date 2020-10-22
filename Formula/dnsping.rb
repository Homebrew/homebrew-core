class Dnsping < Formula
  desc "Like ping but for DNS servers: checks latency and errors and report statistics"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/dnsping.git",
      tag:      "v1.0.0",
      revision: "a02279242d312ed4f60b9803a88e6d3c2431e614"
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
