class Defuddle < Formula
  desc "Extract article content and metadata from web pages"
  homepage "https://defuddle.md"
  url "https://registry.npmjs.org/defuddle/-/defuddle-0.19.5.tgz"
  sha256 "1cbe156e923f38be0e3dc36bb22d1e20d708349b17fd26bb8136b221451f4ae4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "13d22f8a7ff03a7d2b896ee427ddeaaebcb35f3f1a3d188ccddd4c1b89eafe45"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/defuddle --version")

    (testpath/"test.html").write <<~HTML
      <html>
        <body>
          <article>
            <h1>Test Article</h1>
            <p>Hello from Homebrew.</p>
          </article>
        </body>
      </html>
    HTML
    assert_match "Hello from Homebrew.", shell_output("#{bin}/defuddle parse #{testpath}/test.html --md")
    assert_match "Test Article", shell_output("#{bin}/defuddle parse #{testpath}/test.html -p title")
  end
end
