class Htmltest < Formula
  desc "HTML validator written in Go"
  homepage "https://github.com/wjdp/htmltest"
  url "https://github.com/wjdp/htmltest/archive/v0.17.0.tar.gz"
  sha256 "2c89e56c837f4d715db9816942e007c973ba58de53d249abc80430c4b7e72f88"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6af932fffd9a8a5917648b948909a8feaaf80e35cce13d4df74d334a2ccb5841"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "736a23d87214b401dbe5798e60bd8068142e68c010ed68c1d2c076a3c51bf799"
    sha256 cellar: :any_skip_relocation, monterey:       "99bde810401bbdf86f8a10ae9d8a26f1fc9a34b11cad4887947132677795e774"
    sha256 cellar: :any_skip_relocation, big_sur:        "63836ae3db30e6bcbe70768355c9730a4dbd36fae0fed097dd7b6dc220611769"
    sha256 cellar: :any_skip_relocation, catalina:       "6fc34ea39270980857f8777f47e758b08fc1fbbef50fcea6d87a1172231795dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ac1cc7ed8a8917d9050619070c6718e912c9c49d2fd8279f5979256eae20c37"
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
