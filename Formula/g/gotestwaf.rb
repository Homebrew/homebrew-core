class Gotestwaf < Formula
  desc "Tool for API and OWASP attack simulation"
  homepage "https://lab.wallarm.com/test-your-waf-before-hackers/"
  url "https://github.com/wallarm/gotestwaf/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "2ad6e206d039923972b5cc566bc4e212f39b4021236c965207c47601364eb4bf"
  license "MIT"
  head "https://github.com/wallarm/gotestwaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8dbca26ca9e83e4daf1cab913dc9961ecbf391a463ac669862034ae671e90611"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a61479a2941132c45e27793db1ad58ef336c412f9c0369a22c2802edce4351f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98e850ab7f725bf1ac7f4b3b0c72de691361fb53e24d942f16019312ae03c07e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b93586c4d52fefa208d841da07c4ebbf71482912489600dad9d56a9b4bbee37"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ce71f9c93d71d8f42a02feebd186c4fe652437d485b729f4a1a4189034b2dbd"
    sha256 cellar: :any_skip_relocation, ventura:        "bf118301e24e3cc231f82c44238222007c056a6db10377136626eb82e65a7d9d"
    sha256 cellar: :any_skip_relocation, monterey:       "df6744c768034bb2d99804bbc8129cf63a1040995b73b17183e37b2181034bc9"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c46d921e2c4885400afe8b456ae198e5811c4dfcd6d5fc55a61f4cb5e2c6eed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d037638b4f0f687b8d0f8fd5c5ea34e2496490f4d42db5ec2617cbcd774afb99"
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
