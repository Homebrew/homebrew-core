class Gotestwaf < Formula
  desc "Tool for API and OWASP attack simulation"
  homepage "https://lab.wallarm.com/test-your-waf-before-hackers/"
  url "https://github.com/wallarm/gotestwaf/archive/refs/tags/v0.4.15.tar.gz"
  sha256 "58af63bc87a9439cd6df14624020952b0e8ea925bcfefc4f81c42c833a1dfcea"
  license "MIT"
  head "https://github.com/wallarm/gotestwaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "599b758e842e6ce4846a030e6e7549215802ad2c2ec12cbf968306f43cb85f39"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4ab1d2867a4457c84a952943d9f9aca7fe5d2e30df842fb0aabd385875ed147"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "057ee055a4dd5b28a73c5a877ff10052e3fce2c11ff8cdac909f17fe9c202237"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c005d1e593f5cd991dac136ba1a0fa184552e9a3c53e07457df7a2ff104421d"
    sha256 cellar: :any_skip_relocation, ventura:        "1deb2e3eacaeebceac4d63bec6024891f7e7d351ddff9d5cc23bd50d2c377dbc"
    sha256 cellar: :any_skip_relocation, monterey:       "6c0713b0040f4317695f7ebfdb99e82ce97fd45d872ef968fb641f8c9ed3fdcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "113cfc26a4194b70232b1e7306ec328dfd79150604e24e87e51805a863249b57"
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
