class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://jscpd.dev/"
  url "https://github.com/kucherenko/jscpd/archive/refs/tags/v5.4.2.tar.gz"
  sha256 "e51ea154058f92ced612f4f32c366ca16f6e2e87e3743137a79b169a04233bac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "346a16d50e5b291920346713f553bcb1bc542a0d3f9488c9f67019129f44dfe2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "14f3ad3830da1e9043173b07c220cffb4bf12b0996e585a85af92b432fc920f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8adbf9983a6d9d45023d6104dbe8d6881e0d9178341af627a8d8e87c10e2bba5"
    sha256 cellar: :any,                 arm64_linux:       "53b1f435f94b937d25a82ba80f166a4d98200c200356d27faa015b0239e2468b"
    sha256 cellar: :any,                 x86_64_linux:      "817e8bec7392b64392672865c2154437315541080ab8e15e1c9647a3513212b1"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "rust/Cargo.toml"
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
