class Htmltest < Formula
  desc "HTML validator written in Go"
  homepage "https://github.com/wjdp/htmltest"
  url "https://github.com/wjdp/htmltest/archive/v0.17.0.tar.gz"
  sha256 "2c89e56c837f4d715db9816942e007c973ba58de53d249abc80430c4b7e72f88"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2085a020402e7b50b3f536995df8767f4ae61d0839fff353d5e2c246aacd63be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89d683e7134fbf979b69b3ac6d40b9b1990497b628340b1251375a3ed3b7d478"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0fe78109831dc567098f963166d242a8bcff1dd100a4b9d48b4e5abe8c79b4e3"
    sha256 cellar: :any_skip_relocation, ventura:        "306cdfed4300789dfd04480c4ebf16120a1ce8f7e5ecc9dae31ba503a47dc574"
    sha256 cellar: :any_skip_relocation, monterey:       "c3090218a14bc1b7d07c024d6170a9282870d3c43f5d2484dc9580659566e35d"
    sha256 cellar: :any_skip_relocation, big_sur:        "26151c135b1d83a1f14cc600f2e70e69e8d5c1f0cbe7fc0c27287799ef5a454b"
    sha256 cellar: :any_skip_relocation, catalina:       "5318d8a460992bebaf2fd7f0df04d984a9694b5abe86aaac97431359612d3bf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86bac90087af2f141f80bfdc6e3c77220e26ec9097831d030b5f1c4264d7ddbc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.date=#{time.iso8601}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath/"test.html").write <<~EOS
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
    EOS
    assert_match "htmltest started at", shell_output("#{bin}/htmltest test.html")
  end
end
