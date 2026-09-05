class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://jscpd.dev/"
  url "https://github.com/kucherenko/jscpd/archive/refs/tags/v5.1.2.tar.gz"
  sha256 "08dfb94cec707c5fc1aef60bed7c92f7b40a3a725ecdb533adfac0dc0f0c4f37"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5a72c7003c98160d4165f04a5132facc24e67d481d287b898363e5ae43e6557"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89dde750845d758f438007e1cc818c275c982c33d791454c7855ceca2beb9ed6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a1a1ec7ea6e85069b8c866668a8fbeee8d79675829fa06a7765faf0d0da3855"
    sha256 cellar: :any,                 arm64_linux:   "aeb872508e99f24813ec587a728a67c08433f3154285d39399dbb6946da07d7b"
    sha256 cellar: :any,                 x86_64_linux:  "1e9a89977d074b2c9f0e59cdf25771d3da277638c7d44982058507ab98b4d536"
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
