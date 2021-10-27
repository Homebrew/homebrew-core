class Htmlq < Formula
  desc "Uses CSS selectors to extract bits content from HTML files"
  homepage "https://github.com/mgdm/htmlq"
  url "https://github.com/mgdm/htmlq/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "df07a3afbd61824d382961620782c10b0c839d33dbd4d9a2dda261091c830f60"
  license "MIT"
  head "https://github.com/mgdm/htmlq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50250a414769450f0c7a60e7c43a5c0624cec7bdc830363fdf17ac7ba129c4f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "155a5d20ec52baa51c8d5f70f3224ff7707c860a49bc51f020b2afdf8ea1ad2c"
    sha256 cellar: :any_skip_relocation, monterey:       "32c487944df2e353c7723141f8afccea2c1d9c5fb9cba2da07e9719afdca0997"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ec8b00331597e951f4f449394d26549d47c1090d2a1562047268c9ed0397580"
    sha256 cellar: :any_skip_relocation, catalina:       "9be3c8684ee2f1666837195233bfccd29975555f9c7ae36ca1d3870fe0a5ccfc"
    sha256 cellar: :any_skip_relocation, mojave:         "568439b3497a88d0d2fc3b6d7b0e3330c2b93e6a0e0c9df8de17768321a7e9df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee7e22902b6f9bfe4f9403430dfd16fc242d87ee99e59c99358dcbe3a34a1be2"
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
