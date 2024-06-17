class Gotestwaf < Formula
  desc "Tool for API and OWASP attack simulation"
  homepage "https://lab.wallarm.com/test-your-waf-before-hackers/"
  url "https://github.com/wallarm/gotestwaf/archive/refs/tags/v0.4.19.tar.gz"
  sha256 "a19feb83ca8a318826185b405e13dd8cd60634a99ab210c0ee2d467fc5243fd1"
  license "MIT"
  head "https://github.com/wallarm/gotestwaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9ee6fbb09023f7b1a2cb92908f4cac215de2c39ac624c5d7ab6e98687dcc9d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2019715300660c0b8603b175785dac0246ce04b7f7f31dd98059487ec2b7342"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24ce419148d9b633d9c3699682cf65221de82c664dcefcfb7d46f2ffb4d8679e"
    sha256 cellar: :any_skip_relocation, sonoma:         "eef206e255f39cdff38565e941eadc681ff2031e231b1803549b867363d02f89"
    sha256 cellar: :any_skip_relocation, ventura:        "b2e666d2a008d9189ad38203a3d0d90bfd84d230424b79789ceacd5109295af3"
    sha256 cellar: :any_skip_relocation, monterey:       "dd94e88f37fccfe91d042b4b5b45bf7fff93aba57fdc3672cdb107eb740b78f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f22180707e8d3a44046fb9f2a0f4a7b19b272ce17f106dd4849a07e0828618af"
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
