class Defuddle < Formula
  desc "Extract article content and metadata from web pages"
  homepage "https://defuddle.md"
  url "https://registry.npmjs.org/defuddle/-/defuddle-0.19.13.tgz"
  sha256 "888a10efc0ce489732036f5cb4fb4f53da39442495632753361c972c3ac2f54e"
  license "MIT"

  bottle do
    manifest_sha256 "6fab1dddf7e56bcada8f64742d5dc5278677b7baab40addff498016f8910a32b"
    sha256 cellar: :any_skip_relocation, all: "4e36cb72524106eb8fab99718d186ce3778080f5b2f62bc6b48e7cebfb7b37ac"
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
