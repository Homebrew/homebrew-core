class Flamebearer < Formula
  desc "Blazing fast flame graph tool for V8 and Node"
  homepage "https://github.com/mapbox/flamebearer"
  url "https://registry.npmjs.org/flamebearer/-/flamebearer-1.1.3.tgz"
  sha256 "e787b71204f546f79360fd103197bc7b68fb07dbe2de3a3632a3923428e2f5f1"
  license "ISC"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1b939fd19118035fcde87874cde3e22dc9c39140e23d6234c1c18c23967edca0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c60358a7a0492572ad61ea16c4747366addf4d31e360c4a59ec9561f1d725d0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c60358a7a0492572ad61ea16c4747366addf4d31e360c4a59ec9561f1d725d0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c60358a7a0492572ad61ea16c4747366addf4d31e360c4a59ec9561f1d725d0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "461a3c6c6f5a9980766696e8bb718be59f6f758f07ca302a6be7ad97fba362da"
    sha256 cellar: :any_skip_relocation, ventura:        "461a3c6c6f5a9980766696e8bb718be59f6f758f07ca302a6be7ad97fba362da"
    sha256 cellar: :any_skip_relocation, monterey:       "461a3c6c6f5a9980766696e8bb718be59f6f758f07ca302a6be7ad97fba362da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "703f25da914a0c179baf31870d97d396d5b3e8378ce7cefdf16e0c1809f072cd"
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

    assert_predicate testpath/"flamegraph.html", :exist?
  end
end
