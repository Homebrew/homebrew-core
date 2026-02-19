class Htmltest < Formula
  desc "HTML validator written in Go"
  homepage "https://github.com/wjdp/htmltest"
  url "https://github.com/wjdp/htmltest/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "2c89e56c837f4d715db9816942e007c973ba58de53d249abc80430c4b7e72f88"
  license "MIT"
  head "https://github.com/wjdp/htmltest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e5a2f3d0b7eb552f7dcc01be22aef4f16c8ee03c4acebdb07cfc2ce90edfae88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ada8e26674de531245f8110ab62f73f5f89600f133b22765077d14a0ff06f3e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c40c1199909f13636e2a5707f87e17f275efdaeef1f192f34b05e01eeee7491"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2085a020402e7b50b3f536995df8767f4ae61d0839fff353d5e2c246aacd63be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89d683e7134fbf979b69b3ac6d40b9b1990497b628340b1251375a3ed3b7d478"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0fe78109831dc567098f963166d242a8bcff1dd100a4b9d48b4e5abe8c79b4e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "3012d7148925ee8a9234c8b20951f300ecb97a7b7805f3b428edf1ac4b2ae128"
    sha256 cellar: :any_skip_relocation, ventura:        "306cdfed4300789dfd04480c4ebf16120a1ce8f7e5ecc9dae31ba503a47dc574"
    sha256 cellar: :any_skip_relocation, monterey:       "c3090218a14bc1b7d07c024d6170a9282870d3c43f5d2484dc9580659566e35d"
    sha256 cellar: :any_skip_relocation, big_sur:        "26151c135b1d83a1f14cc600f2e70e69e8d5c1f0cbe7fc0c27287799ef5a454b"
    sha256 cellar: :any_skip_relocation, catalina:       "5318d8a460992bebaf2fd7f0df04d984a9694b5abe86aaac97431359612d3bf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c328aad766bee209105e10d41c309e325d47b699eda97323293544c466ed9a17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86bac90087af2f141f80bfdc6e3c77220e26ec9097831d030b5f1c4264d7ddbc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.date=#{time.iso8601}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"test.html").write <<~HTML
      <!DOCTYPE html>
      <html>
        <body>
          <nav>
          </nav>
          <article>
            <p>Some text</p>
          </article>
        </body>
      </html>
    HTML
    assert_match "htmltest started at", shell_output("#{bin}/htmltest test.html")
  end
end
