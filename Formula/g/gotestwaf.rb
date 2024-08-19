class Gotestwaf < Formula
  desc "Tool for API and OWASP attack simulation"
  homepage "https://lab.wallarm.com/test-your-waf-before-hackers/"
  url "https://github.com/wallarm/gotestwaf/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "00047304715f842fd622a0826dcf7729eef29c118b1f645dfa0e3327d62c2173"
  license "MIT"
  head "https://github.com/wallarm/gotestwaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e1d375e095cd8caf3b7552aac5b452c15098a8fa8f324e0e4b4ec5852fce087"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0f10e9825bbb12a7503c9e42bf8725f6f645472eeb979e7b6f934f0f123bf70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6b3fe7b20e9d1029c9bdf29f5503c2ca956d282590303316043db742dd3796c"
    sha256 cellar: :any_skip_relocation, sonoma:         "7dc6de0d1f9943b8add93806213479fb3e520d5f37a3a3eaf2191e97a7b8b3a6"
    sha256 cellar: :any_skip_relocation, ventura:        "3b7f2520b4604469e2be558ec20d93ffff8d43b8f5653479df9643c1ad806005"
    sha256 cellar: :any_skip_relocation, monterey:       "bec8af3bc6611fe5434179881ac8b2740a66caad8876cca2be32eaf62f49cb0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07cd5d3bdf1cc005293d33db25f78dedd8395c0dcf79dd4169e88f83c462eb81"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/wallarm/gotestwaf/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gotestwaf"

    pkgetc.install "config.yaml"
  end

  test do
    cp pkgetc/"config.yaml", testpath

    (testpath/"testcases/sql-injection/test.yaml").write <<~EOS
      ---
      payload:
        - '"union select -7431.1, name, @aaa from u_base--w-'
        - "'or 123.22=123.22"
        - "' waitfor delay '00:00:10'--"
        - "')) or pg_sleep(5)--"
      encoder:
        - Base64Flat
        - Url
      placeholder:
        - UrlPath
        - UrlParam
        - JsonBody
        - Header
    EOS

    output = shell_output("#{bin}/gotestwaf --noEmailReport --url https://example.com/ 2>&1", 1)
    assert_match "Try to identify WAF solution", output
    assert_match "error=\"WAF was not detected", output

    assert_match version.to_s, shell_output("#{bin}/gotestwaf --version 2>&1")
  end
end
