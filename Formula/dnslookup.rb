class Dnslookup < Formula
  desc "Simple command line utility to make DNS lookups using any DNS protocol (DoH, DoT, DNSCrypt, DoQ)"
  homepage "https://github.com/ameshkov/dnslookup/"
  url "https://github.com/ameshkov/dnslookup.git",
      tag:      "v1.4.1",
      revision: "99af6421f9c7f409a2c645d81bd3d8212414296d"
  license "GPL-3.0"

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-X main.VersionString=#{version}",
             *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dnslookup -v")
  end
end
