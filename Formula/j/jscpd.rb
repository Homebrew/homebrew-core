class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://jscpd.dev/"
  url "https://github.com/kucherenko/jscpd/archive/refs/tags/v5.4.3.tar.gz"
  sha256 "617d0f3c5a5ba72e734c30d602d828e0eb77d2ab2d63b4f21cfa112ce19ffae7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c88fe70cf25b83ee86930e1a1e159d8c52dc399611a9738ec0d110d8baa189f2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "518dd55874820ecac67f74bd25473243ee6f0f8cd2b005dda90b992c5c77a68d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "127753b8923a80b214f3ce3e0569d7d7788071d9a924259caa42f759b38eb94c"
    sha256 cellar: :any,                 arm64_linux:       "6d3cbc05cda5895a9c46661e54b76be63f6d015224db444071e05982ef2c278a"
    sha256 cellar: :any,                 x86_64_linux:      "3301143d59e6dc8a9572da8538988de64e62eb04f1d2e02fcd99f192f8622422"
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
