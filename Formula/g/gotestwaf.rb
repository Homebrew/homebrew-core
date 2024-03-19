class Gotestwaf < Formula
  desc "Tool for API and OWASP attack simulation"
  homepage "https://lab.wallarm.com/test-your-waf-before-hackers/"
  url "https://github.com/wallarm/gotestwaf/archive/refs/tags/v0.4.16.tar.gz"
  sha256 "d29e6869470c4209c64bcfb288df69aa87ea293acf423c9d86131a8054f34170"
  license "MIT"
  head "https://github.com/wallarm/gotestwaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "986ba13222dde0fde75b5152f55bd744de8e75e19099c52ec26f7b88b34ebfa9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62e4de324ef4f03218876f45afa0715a7a7e92d7991215cddbe2da893f8bec8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1886b732a99aa8dcde602e7ee980f714dd5322b483874cdaaee5c798eb3fe03"
    sha256 cellar: :any_skip_relocation, sonoma:         "f3adcac30d74966c4ba4c641414fdf8ce563ab880610277f71187e05194481e6"
    sha256 cellar: :any_skip_relocation, ventura:        "473e5ee4540c20424b4001394198bb73cd6bec451922bacc56c7135ae05280f6"
    sha256 cellar: :any_skip_relocation, monterey:       "2946f69c27ce4af3afbdbc1edfe33a2d3610b345812cef6c1de6ffde08fab0cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "755876c3a63e8a20c1f7947bf62be4930b546577a7296ae2b77e853eddb37172"
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
