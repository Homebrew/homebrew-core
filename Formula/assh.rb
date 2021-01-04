class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://manfred.life/assh"
  url "https://github.com/moul/assh/archive/v2.11.0.tar.gz"
  sha256 "8819b847cabddbd1a36893dfeadbbf60346bed14d38e36726248817ff101489c"
  license "MIT"
  head "https://github.com/moul/assh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6762c33fb1336c69c2291490db6a48c14117885e75dbc7567cf70bb4b1ba4fb4" => :big_sur
    sha256 "e12956db15a33133390f2317143315710f6692aad3e5b36fafa3934e43ab3241" => :catalina
    sha256 "2507b79a656698c02c1fb678ebe280ba44326a9f8ec17d4fd355a3843b60253b" => :mojave
    sha256 "359270a9985af3faba8cfe637027d2a4d44ed3b0ce129bd5eb22354eb000bf45" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    assh_config = testpath/"assh.yml"
    assh_config.write <<~EOS
      hosts:
        hosta:
          Hostname: 127.0.0.1
      asshknownhostfile: /dev/null
    EOS

    output = "hosta assh ping statistics"
    assert_match output, shell_output("#{bin}/assh --config #{assh_config} ping -c 4 hosta 2>&1")
  end
end
