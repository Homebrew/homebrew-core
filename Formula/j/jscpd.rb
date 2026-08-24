class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://jscpd.dev/"
  url "https://github.com/kucherenko/jscpd/archive/refs/tags/v5.0.16.tar.gz"
  sha256 "4421519c60876b203643a80f70d9e36a202a1437fc5687ba8f80ba1f26de165b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df69112194fefc65f7f8d7de4b1288be787bc535c164e3735111c8b0b58130fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54b0e899d69cca92e212dc75eafce96b5266726b1495ccee92bcce9838a6c30d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6758cc801776d5d94fd41329e25b8530ef92049e86a0e8ed7790200626207762"
    sha256 cellar: :any_skip_relocation, sonoma:        "68b57bd71115065fe01b917a5f3c30988d9ccf540d01e1f5efe0870da2c754e4"
    sha256 cellar: :any,                 arm64_linux:   "e32d1bfd34e4d5273a866c4185036edc5efa0cdc378fb34a354561adefc8b075"
    sha256 cellar: :any,                 x86_64_linux:  "ead52b7696b408ffe696164de7cfecea14aa07632524ba973325a6b7b95e9114"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/cpd")
  end

  test do
    test_file = testpath/"test.js"
    test_file2 = testpath/"test2.js"
    test_file.write <<~JAVASCRIPT
      console.log("Hello, world!");
    JAVASCRIPT
    test_file2.write <<~JAVASCRIPT
      console.log("Hello, brewtest!");
    JAVASCRIPT

    output = shell_output("#{bin}/jscpd --min-lines 1 #{testpath}/*.js 2>&1")
    assert_match "Found 0 clones", output

    assert_match version.to_s, shell_output("#{bin}/jscpd --version")
  end
end
