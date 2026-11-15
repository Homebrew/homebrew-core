class Gotestwaf < Formula
  desc "Tool for API and OWASP attack simulation"
  homepage "https://lab.wallarm.com/test-your-waf-before-hackers/"
  url "https://github.com/wallarm/gotestwaf/archive/refs/tags/v0.5.11.tar.gz"
  sha256 "4f80879d0e8e4fc81c98c720f3ee7352f4e50176dac84442124c92ea3a886027"
  license "MIT"
  head "https://github.com/wallarm/gotestwaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "33f76dee16655553540f43ac66859cc5f15eb3b817378dd2c06c5b302d45d007"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "33f76dee16655553540f43ac66859cc5f15eb3b817378dd2c06c5b302d45d007"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "33f76dee16655553540f43ac66859cc5f15eb3b817378dd2c06c5b302d45d007"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "56091edb73c266f609ac6f5f053a8c995fe9b6e6d03d899f3be801ab884ad7a5"
    sha256 cellar: :any,                 x86_64_linux:      "6b92abd630763516312773a1cefa301e740a66df6d804d76d4b41b3d4c668b6e"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/wallarm/gotestwaf/internal/version.Version=#{version}"
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
