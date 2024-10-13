class Gotestwaf < Formula
  desc "Tool for API and OWASP attack simulation"
  homepage "https://lab.wallarm.com/test-your-waf-before-hackers/"
  url "https://github.com/wallarm/gotestwaf/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "082873729d0d5dc7a26feaca277a11b7a5fab937d63da76ac0b1c2c6c1932b41"
  license "MIT"
  head "https://github.com/wallarm/gotestwaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c2cf2b8f149605d7305fa0750230a3f185ff55374b38339482a8dc46ef4e0c53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8777609c6958798e93cf701c388a557aefa1b69bcdce5524c9f5fe0f3fdcee2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8777609c6958798e93cf701c388a557aefa1b69bcdce5524c9f5fe0f3fdcee2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8777609c6958798e93cf701c388a557aefa1b69bcdce5524c9f5fe0f3fdcee2a"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e28e19b5b2dc3e5bbb96bd8a619cbb600e346ee1bc04fae68c746d2d1f667b6"
    sha256 cellar: :any_skip_relocation, ventura:        "6e28e19b5b2dc3e5bbb96bd8a619cbb600e346ee1bc04fae68c746d2d1f667b6"
    sha256 cellar: :any_skip_relocation, monterey:       "6e28e19b5b2dc3e5bbb96bd8a619cbb600e346ee1bc04fae68c746d2d1f667b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0cacf3005ca5e492545190ec9972a47a88106f0ad3fc740407c71221ff0959a"
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
