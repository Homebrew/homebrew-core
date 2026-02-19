class Htmlhint < Formula
  desc "Static code analysis tool you need for your HTML"
  homepage "https://github.com/htmlhint/HTMLHint"
  url "https://registry.npmjs.org/htmlhint/-/htmlhint-1.9.1.tgz"
  sha256 "41d36d5414ba305ceeaa757ef61444c6da02a32aa079eaaf7fc1379ae1e7de2a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "575f7e3a2ab47d184383ddc7a62b88be0428456817de36df7a4bf1d3d371fbfd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/htmlhint --version")

    (testpath/"invalid.html").write <<~EOS
      <!DOCTYPE html>
      <html>
      <head>
        <title>Test</title>
      </head>
      <body>
        <h1>Hello World</h2>
        <img src="test.png">
        <a href="#" target="_blank">Link</a>
      </body>
      </html>
    EOS

    output = shell_output("#{bin}/htmlhint #{testpath}/invalid.html", 1)
    assert_match "Tag must be paired", output
    assert_match "Scanned 1 files, found 2 errors in 1 files", output

    (testpath/"valid.html").write <<~EOS
      <!DOCTYPE html>
      <html>
      <head>
        <title>Test</title>
      </head>
      </html>
    EOS

    output = shell_output("#{bin}/htmlhint #{testpath}/valid.html")
    assert_match "Scanned 1 files, no errors found", output
  end
end
