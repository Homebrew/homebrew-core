class Flamebearer < Formula
  desc "Blazing fast flame graph tool for V8 and Node"
  homepage "https://github.com/mapbox/flamebearer"
  url "https://registry.npmjs.org/flamebearer/-/flamebearer-1.1.3.tgz"
  sha256 "e787b71204f546f79360fd103197bc7b68fb07dbe2de3a3632a3923428e2f5f1"
  license "ISC"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "fa4b1af3c1cbdce03df418410f78ada2b106c7383539b2f7a9e5183ba2b75b71"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"app.js").write "console.log('hello');"
    system Formula["node"].bin/"node", "--prof", testpath/"app.js"
    logs = testpath.glob("isolate*.log")

    assert_match "Processed V8 log",
      pipe_output(
        bin/"flamebearer",
        shell_output("#{Formula["node"].bin}/node --prof-process --preprocess -j #{logs.join(" ")}"),
      )

    assert_path_exists testpath/"flamegraph.html"
  end
end
