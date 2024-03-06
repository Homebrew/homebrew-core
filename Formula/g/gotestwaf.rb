class Gotestwaf < Formula
  desc "Tool for API and OWASP attack simulation"
  homepage "https://lab.wallarm.com/test-your-waf-before-hackers/"
  url "https://github.com/wallarm/gotestwaf/archive/refs/tags/v0.4.15.tar.gz"
  sha256 "58af63bc87a9439cd6df14624020952b0e8ea925bcfefc4f81c42c833a1dfcea"
  license "MIT"
  head "https://github.com/wallarm/gotestwaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4db2685cfa30ca253751fe3811d0775404d762792038c342db2a115370f72303"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "184e895d33d3fbb28d782c859d3bd8f4477a58cf7ffd4728a5ce2ea4c9318225"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87fc85e5c7cf49c25ad3c1e195c8da137e3f718efd9df8378251d56fbcd8bd81"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e06fe1e54d1b37b4cbeae792ac8ba7098a285d0031deee62e7cbd667ea81d87"
    sha256 cellar: :any_skip_relocation, ventura:        "32115bf4c8a6bd29edf4396a7480e67b31e309b558e85dbe0ed393d5ccfbc663"
    sha256 cellar: :any_skip_relocation, monterey:       "79581b7eed7a078c826b70d711af01fad9476b3b0b0e7efb5ae350a05e555a00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e9ba532ddc351dcf2b374cd33d62f18eb81a4f7d38137a0e2ee44dee31c0e10"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/wallarm/gotestwaf/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd"

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
