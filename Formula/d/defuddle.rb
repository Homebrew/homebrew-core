class Defuddle < Formula
  desc "Extract article content and metadata from web pages"
  homepage "https://defuddle.md"
  url "https://registry.npmjs.org/defuddle/-/defuddle-0.19.13.tgz"
  sha256 "888a10efc0ce489732036f5cb4fb4f53da39442495632753361c972c3ac2f54e"
  license "MIT"

  bottle do
    manifest_sha256 "98c440bb2979a7cd5dfdd0b4816c9f7b479094e9f6b66fab0c07f6af64124d49"
    sha256 cellar: :any_skip_relocation, all: "dde95e59f342cdd2d373b22418e1a27e062fbfe8511625bc045e362a459594c6"
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
