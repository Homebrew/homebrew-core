class Hq < Formula
  desc "Jq, but for HTML"
  homepage "https://github.com/orf/hq"
  url "https://github.com/orf/hq/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "6f761a301a38b27d7be9b536100003f361fecaf42639750d3c86096ec56a90b9"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    html = testpath/"test.html"
    html.write <<~EOS
      <p class="foo">Test</p>
    EOS
    output = shell_output("#{bin}/hq '{foo: .foo}' test.html")
    assert_match '{"foo":"Test"}', output
  end
end
