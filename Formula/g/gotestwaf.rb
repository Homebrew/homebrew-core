class Gotestwaf < Formula
  desc "Tool for API and OWASP attack simulation"
  homepage "https://lab.wallarm.com/test-your-waf-before-hackers/"
  url "https://github.com/wallarm/gotestwaf/archive/refs/tags/v0.4.12.tar.gz"
  sha256 "0d116512eab0b7d60dea6c16f92d12f2556940232f764ac28b50d4749b0cfa5d"
  license "MIT"
  head "https://github.com/wallarm/gotestwaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "afca70641affa963f5b1211af36950c4313f068182ad9fcfe5dd9c1f87d89450"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5dc88f33d323339dc93dfc139ae1b50f3d720d41047b8de347143eaba637ddc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12282dd801abd3e033d26c069f33fd262153d09d5561e763672a4b4f7e15d16b"
    sha256 cellar: :any_skip_relocation, sonoma:         "06fc9f27bd66372b64b8bd0340a010b8855c2b33939eea62f274c6d1e723f0e0"
    sha256 cellar: :any_skip_relocation, ventura:        "dd7486f20ab2fb47a6a006528fec5efa7742864b90463a9c4fff9a68a70191ea"
    sha256 cellar: :any_skip_relocation, monterey:       "f2b108841bed6ad03fbf5a960d08277fc85ebf06267c9b32e3aafeeab12263b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1718e4bc83f7eaa98e0ce84858def17d9f3a249f635c050902710ca181a245d8"
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
