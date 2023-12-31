class Gotestwaf < Formula
  desc "Tool for API and OWASP attack simulation"
  homepage "https://lab.wallarm.com/test-your-waf-before-hackers/"
  url "https://github.com/wallarm/gotestwaf/archive/refs/tags/v0.4.9.tar.gz"
  sha256 "1146ec43b3e801a6b02e2a976805f15346eaba26f2b288e7a1ad57014bf07da1"
  license "MIT"
  head "https://github.com/wallarm/gotestwaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6667b782e98a5b779f1a8af77097b17d621db3e6ca7b0d9c138d7776afc29929"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "970f7d45afcd23f85e71b38fcbba634a816caa5ecc216d70685f084d7f5b3617"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8720b72f30b0b340c340ccda1b2e737359a4811e3071f3d335f2b7761c73af83"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a59785486d9eaaff01d630fde285cdbb98b022439dbfe07c935526e6b9c7f62"
    sha256 cellar: :any_skip_relocation, ventura:        "04bdc6704a4026775c832b75601bc4b62fbb4564c4ab4213c50fad04883ff818"
    sha256 cellar: :any_skip_relocation, monterey:       "2b63c223828abc236626667dc31ca8fe2bfd5f35f37814f6dc83b86ba66bf926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "359a07fa94b7d3fd77eaf9aabeb8f66faace83bdf63829d8c85e3691ba27afc5"
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
    output = shell_output("#{bin}/gotestwaf --url https://example.com/ 2>&1", 1)
    assert_match "Try to identify WAF solution", output
    assert_match "error=\"WAF was not detected", output

    assert_match version.to_s, shell_output("#{bin}/gotestwaf --version 2>&1")
  end
end
