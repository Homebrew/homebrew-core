class Gotestwaf < Formula
  desc "Tool for API and OWASP attack simulation"
  homepage "https://lab.wallarm.com/test-your-waf-before-hackers/"
  url "https://github.com/wallarm/gotestwaf/archive/refs/tags/v0.4.18.tar.gz"
  sha256 "97f0c0f3eeaf1811757d2c0d7e1732d1255b6c2ad4565f9eb5d5ead3c723c037"
  license "MIT"
  head "https://github.com/wallarm/gotestwaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0a53650b3b38b74f6a48443f8d87c9b3a87efaa8c63036738415ba160db9e8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88509f7e38931d3e18f02427df68dcc4e919e4c30646b6bfc9846694b758b417"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4deda16e9ee60bc3f9eac767e3d6dae564a7925cbb23fff0f508ae419a0187b"
    sha256 cellar: :any_skip_relocation, sonoma:         "af786a3f5fee28a72d9f95a4b382b7096b0ade7fa2cfd8bd6ee64fd0657160d7"
    sha256 cellar: :any_skip_relocation, ventura:        "01d1757277bee268dc0260a5513eb49074ac6ddd9cf8f19cc7ff5cbfb4ac5fe6"
    sha256 cellar: :any_skip_relocation, monterey:       "a9e157298a86fcc1bbc9cb241538b6ce0a48f22d6c54315d0725e31c24bcdb04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d964375f35aa6c55c010e679c15fdd2a7c2237db672d7c4333af4b559cfeeeb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/wallarm/gotestwaf/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd"

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
