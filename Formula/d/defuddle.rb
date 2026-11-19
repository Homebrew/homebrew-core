class Defuddle < Formula
  desc "Extract article content and metadata from web pages"
  homepage "https://defuddle.md"
  url "https://registry.npmjs.org/defuddle/-/defuddle-0.19.7.tgz"
  sha256 "0bac9deb609680e84ac8357f5c275038e3b867ec9566f1f539328b19f7e821cd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cd9e165f041d754b7ef26db2c1dc5443bebd9ede975745db75c33cfb394b30ac"
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
