class Htmlq < Formula
  desc "Uses CSS selectors to extract bits content from HTML files"
  homepage "https://github.com/mgdm/htmlq"
  url "https://github.com/mgdm/htmlq/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "c2954c0fcb3ada664b14834646aa0a2c4268683cc51fd60d47a71a9f7e77d4b9"
  license "MIT"
  head "https://github.com/mgdm/htmlq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f975cfa431fbc03c5bc6eab5372313d95b38ce7a19e558a80021d2ac17c15fb4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa4eae2da351814a51f9332500c83b3c18360a2ffabbaaa9126fd7bae21e7421"
    sha256 cellar: :any_skip_relocation, monterey:       "317689afb09ecbb2d08be598aafd16fcdf9b674868aadab1bff1128d4829ce94"
    sha256 cellar: :any_skip_relocation, big_sur:        "b136ace66829daaa18c37c91d7bdae098b71c39aedf4cb86d436efd6108d8209"
    sha256 cellar: :any_skip_relocation, catalina:       "189fa5d4f2a99d4bb7b2002c89da361383a56fbac8c246b1a2fd52a00e2ca825"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "263b6af3a39eb169667349f20261e90faebf9446e350496649a9f51d57de49d3"
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
