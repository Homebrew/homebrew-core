class Defuddle < Formula
  desc "Extract article content and metadata from web pages"
  homepage "https://github.com/kepano/defuddle"
  url "https://registry.npmjs.org/defuddle/-/defuddle-0.18.1.tgz"
  sha256 "29d634b3e633e7ca0bd56fcb6296611b1f85e1823cd9bc1fe3220f1112149aec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f5ad5cfe3fae1be629c6a6fdfe83c038e4abad5690e477e0b1727b3db6acdaca"
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
