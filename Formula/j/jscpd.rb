class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://jscpd.dev/"
  url "https://github.com/kucherenko/jscpd/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "a0287018300ebee9e406793b54f2df106be1eee5cdab94c6172cdd5869b49d39"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9a4e418733c58915e2af1fef52ecca3eac2c7073e204b4eb076ed36f429e186a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c0698ca50ed6feb4b0c55bd8272e025042580ff80fd8fd21582f262a6bc515ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "83137e60fd49674d84d9e9cf1cedd38e6aedd88f5df74a9ad52056f3026912c0"
    sha256 cellar: :any,                 arm64_linux:       "bfa8c7989e320e984db789cfaa795afa8158654b71e2f7b10dc30b9ca9958109"
    sha256 cellar: :any,                 x86_64_linux:      "10ade997af4bdb669dd684617e1b3ad182a4d3d07e2ccf755d68fcae17891a43"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple", "--manifest-path", "rust/Cargo.toml"
  end

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
