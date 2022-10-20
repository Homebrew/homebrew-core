require "language/node"

class Flamebearer < Formula
  desc "Blazing fast flame graph tool for V8 and Node"
  homepage "https://github.com/mapbox/flamebearer"
  url "https://registry.npmjs.org/flamebearer/-/flamebearer-1.1.3.tgz"
  sha256 "e787b71204f546f79360fd103197bc7b68fb07dbe2de3a3632a3923428e2f5f1"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c58234912fa727a85aa1f072c14a7fd49aae68ff6023325baf045ddec3b7c3a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c58234912fa727a85aa1f072c14a7fd49aae68ff6023325baf045ddec3b7c3a1"
    sha256 cellar: :any_skip_relocation, monterey:       "98988646062bd8230583e9bbb7cad33fadcde48cae70d92a6011580494cc84f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "98988646062bd8230583e9bbb7cad33fadcde48cae70d92a6011580494cc84f6"
    sha256 cellar: :any_skip_relocation, catalina:       "98988646062bd8230583e9bbb7cad33fadcde48cae70d92a6011580494cc84f6"
    sha256 cellar: :any_skip_relocation, mojave:         "98988646062bd8230583e9bbb7cad33fadcde48cae70d92a6011580494cc84f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c58234912fa727a85aa1f072c14a7fd49aae68ff6023325baf045ddec3b7c3a1"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"app.js").write "console.log('hello');"
    system Formula["node"].bin/"node", "--prof", testpath/"app.js"
    logs = testpath.glob("isolate*.log")

    assert_match "Processed V8 log",
      pipe_output(
        "#{bin}/flamebearer",
        shell_output("#{Formula["node"].bin}/node --prof-process --preprocess -j #{logs.join(" ")}"),
      )

    assert_predicate testpath/"flamegraph.html", :exist?
  end
end
