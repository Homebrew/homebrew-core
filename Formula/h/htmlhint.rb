class Htmlhint < Formula
  desc "Static code analysis tool you need for your HTML"
  homepage "https://github.com/htmlhint/HTMLHint"
  url "https://registry.npmjs.org/htmlhint/-/htmlhint-1.6.3.tgz"
  sha256 "2f525186e3d3066de002822a11672b98869b647be8de709c130861a60d245dec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "beb428615aec8f7104f3cffd5a1eb2c016c5a58d911f8aef359063f90d677299"
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
