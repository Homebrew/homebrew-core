class Htmltest < Formula
  desc "HTML validator written in Go"
  homepage "https://github.com/wjdp/htmltest"
  url "https://github.com/wjdp/htmltest/archive/v0.15.0.tar.gz"
  sha256 "d8a8fa1f7ce6cf7a05401fa7ae3f1dd85e4abb2f0354f8825a2e628d4824df9b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7507678413c0f673c241ba842bb27138c875356df6cdc67ceb7c1906a4b7a8d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c56728f224b74a174a7a0dd84632a00fc514497a0770d907420af74bc668a32f"
    sha256 cellar: :any_skip_relocation, monterey:       "ce41afd6ef389eeeaf5c9b26a9423e03ea562a6349ad7248664a3a1afbf699d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "02514122a2096f262dbd9fb76726eae3e375d5ed6fa682e465551e694ac48072"
    sha256 cellar: :any_skip_relocation, catalina:       "3bf67d5d510e565c05e18f03cb36efbf07c5f6f9a7a175375b5b662f2ea51037"
    sha256 cellar: :any_skip_relocation, mojave:         "19196540163714c7de59083a8957e8670b4befba3e3c6f2217ff308c3b1be824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f69d59bdeeafbb3d552668b1d8dc387b90eefbae9ae78489b71fd324463d3658"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.date=#{time.iso8601}
      -X main.version=#{version}
    ].join(" ")
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
