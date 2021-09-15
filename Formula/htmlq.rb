class Htmlq < Formula
  desc "Uses CSS selectors to extract bits content from HTML files"
  homepage "https://github.com/mgdm/htmlq"
  url "https://github.com/mgdm/htmlq/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "559f4ff25b0b8014d5b4e72cd06c20f40e5f0cf07a88dc0467418a6b2d7d5075"
  license "MIT"
  head "https://github.com/mgdm/htmlq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "870d5212cca94a0bd9cfadfeb02b729ff2b248acd3aff5a54b2d2497e2e1a90f"
    sha256 cellar: :any_skip_relocation, big_sur:       "612666a8de0e0f57bdebac0382abbf2b561985f68d9dcd09ca81f66da7529d20"
    sha256 cellar: :any_skip_relocation, catalina:      "78efcef9657905e874fc01828c64a9a16532bb7941ce7e84e2745538d78a646d"
    sha256 cellar: :any_skip_relocation, mojave:        "f9829e731e39ec1e08570ddf6112c186df0f2c76e4ea96941858bf86eae95764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a405ebf5e98497ecc0ecea210e68bce8b20339d7403eec97a451f2e8ce8cad7c"
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
