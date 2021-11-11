class Cidr2ip < Formula
  desc "Converts CIDRs to IPs"
  homepage "https://ipinfo.io"
  url "https://github.com/ipinfo/cli/archive/cidr2ip-1.0.0.tar.gz"
  sha256 "6b34330f0b27f403c251ebd40c8f3cf56bb0662cc24f71bf960ea792066ab767"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cidr2ip[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cidr2ip"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/cidr2ip --version").chomp
    assert_equal "8.8.8.8", shell_output("#{bin}/cidr2ip 8.8.8.8/32").chomp
    assert_equal "1.1.1.0\n1.1.1.1\n1.1.1.2\n1.1.1.3", shell_output("#{bin}/cidr2ip 1.1.1.0/30").chomp
  end
end
