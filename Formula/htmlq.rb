class Htmlq < Formula
  desc "Uses CSS selectors to extract bits content from HTML files"
  homepage "https://github.com/mgdm/htmlq"
  url "https://github.com/mgdm/htmlq/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "c2954c0fcb3ada664b14834646aa0a2c4268683cc51fd60d47a71a9f7e77d4b9"
  license "MIT"
  head "https://github.com/mgdm/htmlq.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b48cd78910d620c598a8102cc8801f0155b8aee452440b6f6d965e931488906"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e03e8a2c059ad4ac3454ad2b4cc70fb77e7883d7141f6f10d8a9bfe9c421b53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abf6473f80399fc7dd8252a2c35dff388c142ca028de0128b26defc46f6f107f"
    sha256 cellar: :any_skip_relocation, ventura:        "dd3223cb5afa829c8519e42515d06f56d6d815794af40d8c7ff932aacb3d3634"
    sha256 cellar: :any_skip_relocation, monterey:       "c2dc9b6cb1914175ee46979f7edcf7d6883b9234da5f85711fd7f58ebef11e44"
    sha256 cellar: :any_skip_relocation, big_sur:        "f14e7cff6db455661e178db9d57b3b5cbc172c4bc3903d959ee1b5f38bf816a2"
    sha256 cellar: :any_skip_relocation, catalina:       "4a790da130fb9f4db4d43051df1fbcf409b6dbd49293d757411cd5118c9e18e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b93418d06723d65a8da8cb3c34819f24f825a057efc7788bf45f0db3484abf13"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.html").write <<~EOS
      <!doctype html>
      <html>
        <head>
            <title>Example Domain</title>
            <meta charset="utf-8" />
            <meta http-equiv="Content-type" content="text/html; charset=utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1" />
        </head>
        <body>
            <div>
              <h1>Example Domain</h1>
              <p>This domain is for use in illustrative examples in documents. You may use this domain in literature without prior coordination or asking for permission.</p>
              <p><a href="https://www.iana.org/domains/example">More information...</a></p>
            </div>
        </body>
      </html>
    EOS

    test_html = testpath/"test.html"
    assert_equal "More information...\n", pipe_output("#{bin}/htmlq -t p a", test_html.read)
    assert_equal "Example Domain\n", pipe_output("#{bin}/htmlq -t h1:first-child", test_html.read)
  end
end
