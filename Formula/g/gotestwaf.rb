class Gotestwaf < Formula
  desc "Tool for API and OWASP attack simulation"
  homepage "https://lab.wallarm.com/test-your-waf-before-hackers/"
  url "https://github.com/wallarm/gotestwaf/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "8edd398b694de728894055f80d4809bdfa762aa25e9d29e86fdccee62ac2e1ae"
  license "MIT"
  head "https://github.com/wallarm/gotestwaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f9b83b297bbab0ec18a8ad46548c809e98236377504480df8906d455b779907"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f9b83b297bbab0ec18a8ad46548c809e98236377504480df8906d455b779907"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f9b83b297bbab0ec18a8ad46548c809e98236377504480df8906d455b779907"
    sha256 cellar: :any_skip_relocation, sonoma:        "2203a337bacd42b4f98abee68eb59165faad3d550ab294bf6934c79f84db048b"
    sha256 cellar: :any_skip_relocation, ventura:       "2203a337bacd42b4f98abee68eb59165faad3d550ab294bf6934c79f84db048b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2880f1b1762dc091122914a8dd64a94605b4fce326354e32d984f7681abd0b9b"
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
