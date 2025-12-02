class Ptunnel < Formula
  desc "Tunnel over ICMP"
  homepage "https://www.cs.uit.no/~daniels/PingTunnel/"
  url "https://www.cs.uit.no/~daniels/PingTunnel/PingTunnel-0.72.tar.gz"
  sha256 "b318f7aa7d88918b6269d054a7e26f04f97d8870f47bd49a76cb2c99c73407a4"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?PingTunnel[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "0049b270a67c200fc498f50bfa732e2812106e758b2ee1eac0e43ca41e48c241"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fc5d1df7e57ad9f2fe35f68eef503fd2f9bf7da2edc2d0374acc3a37891ee13e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d848b4fd2c1139d8ae71d471f17fec38d775c6d6a24db390d1abdc425d4a522c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1de9c44033945ce32afe27993fee10ab0811b3fa64c50482dbb046feeb92c34b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d64c07c1f6080241961bd8744f5990af83217198b6385a2a878c10e5e4e8352"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "706c9eaf3a158032cf0f361ceee4779ef2afe74f515853405afd24cc9c6e8ade"
    sha256 cellar: :any_skip_relocation, sonoma:         "f65aa88ce0023383667679f121c2c849fe0391b6684ddb25d79255d18773a67b"
    sha256 cellar: :any_skip_relocation, ventura:        "42d5d51d090829c42004c09ee3558247818c654f2adc25ea39f377f0c3cc54ee"
    sha256 cellar: :any_skip_relocation, monterey:       "58964687f840c6e5c7b785060b23068ab6735c798a284bd07bd8457747717def"
    sha256 cellar: :any_skip_relocation, big_sur:        "23ebdbcf1362144e6fc8b02d950ee43e6216338b940fd90c471a132c0e5f49b3"
    sha256 cellar: :any_skip_relocation, catalina:       "15d1785092ce8788e96232fc051be9311aaa6565c6a65dfbb96d0ec597970384"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8b8e66df9c54317634708382da6d32f7d5f0e8fa5b2e6a226dae499338e335ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "635b36ee0d56fa5b28aebb302aad7d8d3e922c4a143854b17cc8087e7f2c0683"
  end

  uses_from_macos "libpcap"

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  def caveats
    <<~EOS
      Normally, ptunnel uses raw sockets and must be run as root (using sudo, for example).

      Alternatively, you can try using the -u flag to start ptunnel in 'unprivileged' mode,
      but this is not recommended. See https://www.cs.uit.no/~daniels/PingTunnel/ for details.
    EOS
  end

  test do
    assert_match "v #{version}", shell_output("#{bin}/ptunnel -h", 1)
  end
end
