class Htmltest < Formula
  desc "HTML validator written in Go"
  homepage "https://github.com/wjdp/htmltest"
  url "https://github.com/wjdp/htmltest/archive/v0.15.0.tar.gz"
  sha256 "d8a8fa1f7ce6cf7a05401fa7ae3f1dd85e4abb2f0354f8825a2e628d4824df9b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "62b0968b1a9b25c2f72e6f35bf440f5393c58981ab8d3ae592ec6a1b15a17fbc"
    sha256 cellar: :any_skip_relocation, big_sur:       "56ada97849ef9e1c525838c0739c6034ea92c560576b18a22ce3089eba7cc340"
    sha256 cellar: :any_skip_relocation, catalina:      "046159e1bc0d2c590a9f38c00fe9628e8abd2ac5c5797f3bcd33c8387c21c378"
    sha256 cellar: :any_skip_relocation, mojave:        "496943d4cd10178d81ee420902f36e3691f7a97ac65ded868f88631235ac71c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c48eee74bcc5f63eac4bdaf9f07ef57c49fe1a80d7c7f49f49bdcd84363ca45d"
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
