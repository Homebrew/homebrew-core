class Defuddle < Formula
  desc "Extract article content and metadata from web pages"
  homepage "https://defuddle.md"
  url "https://registry.npmjs.org/defuddle/-/defuddle-0.19.11.tgz"
  sha256 "964ee80e688220c342af7ea603fd0820571e64ee8c352daab73da9231e83fcbf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1ff483d3e3dbac379d4347bdf4328a8ceaf56c09cf181507de3505faeb916d39"
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
