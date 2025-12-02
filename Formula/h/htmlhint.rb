class Htmlhint < Formula
  desc "Static code analysis tool you need for your HTML"
  homepage "https://github.com/htmlhint/HTMLHint"
  url "https://registry.npmjs.org/htmlhint/-/htmlhint-1.8.0.tgz"
  sha256 "16e096ffc05118ba700494c79058dd3c9f7530a05426e28a1f7b878abc1afecb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ef6d5e5087c7879fc0b7e4eba6f2c4cded6d2d531324daec59885c6f94556039"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
