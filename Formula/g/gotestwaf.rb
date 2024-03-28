class Gotestwaf < Formula
  desc "Tool for API and OWASP attack simulation"
  homepage "https://lab.wallarm.com/test-your-waf-before-hackers/"
  url "https://github.com/wallarm/gotestwaf/archive/refs/tags/v0.4.17.tar.gz"
  sha256 "bc4c1b8a7fc8b6db2df82ca56942b8d333bd17d75e0e93b4e110663370cef717"
  license "MIT"
  head "https://github.com/wallarm/gotestwaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98bfd4fd884f4f976a7484587e487b0b0bc9c7a90c978a5a86946597f05839f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5b3d73850596159cc58bf9ff10cbd28e918737149b6de92dc869b8640690888"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4374453bac37d3d278e09d65059fb22d95ab5372726950b993f8707d2da9efe9"
    sha256 cellar: :any_skip_relocation, sonoma:         "a69456e96d25bb1a791f61ea8440654e7021312e0485f31b11bc5c71d17da85b"
    sha256 cellar: :any_skip_relocation, ventura:        "95e0a16ea72104ef3d6228d7b408ccb9a25e2877424f95dabe09191f51ce37bd"
    sha256 cellar: :any_skip_relocation, monterey:       "48ab320563dd1978660da1a9ccd5c6181cc800b2722fb7fc6fa988377862323a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5365087b5eb1ff7998348e4f621740b80f78c706ca94e57815b598fd285d375f"
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
