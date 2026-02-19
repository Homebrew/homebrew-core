class Gotestwaf < Formula
  desc "Tool for API and OWASP attack simulation"
  homepage "https://lab.wallarm.com/test-your-waf-before-hackers/"
  url "https://github.com/wallarm/gotestwaf/archive/refs/tags/v0.5.8.tar.gz"
  sha256 "46e6cf3f07957aa58683447572cb9bd68c51aa684b3a5f84439f0f1cbd83621c"
  license "MIT"
  head "https://github.com/wallarm/gotestwaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc87754a9989cda5d3ae5bc5c08b286956f457395b37b09d5523213060e84fcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b2f734f1ed87f7a69a4358c38d0d0041dcd4a8cfbdbd853752cf8663269c361"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b2f734f1ed87f7a69a4358c38d0d0041dcd4a8cfbdbd853752cf8663269c361"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b2f734f1ed87f7a69a4358c38d0d0041dcd4a8cfbdbd853752cf8663269c361"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9ba660878866bb9683bc9088c8d1b4dff7e8bc6e63a244b4197a02f214dc3e6"
    sha256 cellar: :any_skip_relocation, ventura:       "d9ba660878866bb9683bc9088c8d1b4dff7e8bc6e63a244b4197a02f214dc3e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d70cda56e9eb2065923ad47c7598c87b01c5d18f46e69df22b59eff89fd76c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea85ed53e64ccd081738ee8b3e80b311128ffdd9ad44d284b956cfd1df8ce86f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/wallarm/gotestwaf/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gotestwaf"

    pkgetc.install "config.yaml"
  end

  test do
    cp pkgetc/"config.yaml", testpath

    (testpath/"testcases/sql-injection/test.yaml").write <<~YAML
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
    YAML

    output = shell_output("#{bin}/gotestwaf --noEmailReport --url https://example.com/ 2>&1", 1)
    assert_match "Try to identify WAF solution", output
    assert_match "error=\"WAF was not detected", output

    assert_match version.to_s, shell_output("#{bin}/gotestwaf --version 2>&1")
  end
end
