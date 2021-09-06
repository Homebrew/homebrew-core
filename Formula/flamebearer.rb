require "language/node"

class Flamebearer < Formula
  desc "Blazing fast flame graph tool for V8 and Node"
  homepage "https://github.com/mapbox/flamebearer"
  url "https://registry.npmjs.org/flamebearer/-/flamebearer-1.1.3.tgz"
  sha256 "e787b71204f546f79360fd103197bc7b68fb07dbe2de3a3632a3923428e2f5f1"
  license "ISC"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"app.js").write "console.log('hello');"
    system Formula["node"].bin/"node", "--prof", testpath/"app.js"
    assert_match "Processed V8 log",
      shell_output("#{Formula["node"].bin}/node --prof-process --preprocess -j isolate*.log | #{bin}/flamebearer")
    assert_predicate testpath/"flamegraph.html", :exist?
  end
end
