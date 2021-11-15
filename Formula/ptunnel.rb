class Ptunnel < Formula
  desc "Tunnel over ICMP"
  homepage "https://www.cs.uit.no/~daniels/PingTunnel/"
  url "https://www.cs.uit.no/~daniels/PingTunnel/PingTunnel-0.72.tar.gz"
  sha256 "b318f7aa7d88918b6269d054a7e26f04f97d8870f47bd49a76cb2c99c73407a4"

  livecheck do
    url :homepage
    regex(/href=.*?PingTunnel[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d64c07c1f6080241961bd8744f5990af83217198b6385a2a878c10e5e4e8352"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "706c9eaf3a158032cf0f361ceee4779ef2afe74f515853405afd24cc9c6e8ade"
    sha256 cellar: :any_skip_relocation, monterey:       "58964687f840c6e5c7b785060b23068ab6735c798a284bd07bd8457747717def"
    sha256 cellar: :any_skip_relocation, big_sur:        "23ebdbcf1362144e6fc8b02d950ee43e6216338b940fd90c471a132c0e5f49b3"
    sha256 cellar: :any_skip_relocation, catalina:       "15d1785092ce8788e96232fc051be9311aaa6565c6a65dfbb96d0ec597970384"
    sha256 cellar: :any_skip_relocation, mojave:         "3c8f8ec4d66e42ad4a6513a4c92e0f3e0babfebe25fb08ff4c690b1a37557fdd"
    sha256 cellar: :any_skip_relocation, high_sierra:    "67bd833b70dc704ab565d526fd99044e122a4e2fcd583b083db0a5f642d46041"
    sha256 cellar: :any_skip_relocation, sierra:         "048404c7b3fe3365abfc24fb623bf9548ed7e61458a00148348bbdc2f5f12f33"
    sha256 cellar: :any_skip_relocation, el_capitan:     "516181dbd16539c1f8817d65637bd42cc951d551e1a3b61a4d83dc6c71dc6397"
    sha256 cellar: :any_skip_relocation, yosemite:       "72db3faba8fbd7c268acf22d02ae0df4dbb5dde2db8a17ca4d62b2293d0763e0"
  end

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
