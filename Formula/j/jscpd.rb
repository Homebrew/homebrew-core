class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://jscpd.dev/"
  url "https://github.com/kucherenko/jscpd/archive/refs/tags/v5.0.12.tar.gz"
  sha256 "2205f844a8995cb2d3ca669cd53a16e12e0f52a9f9e55a3e04a2e4494977016e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56039f3474f9c256069c324157017235759bba1bab1d8ae2d128d1195597c9cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83c3548859692d49967863f525788dfceb4ab8e9523d2d0eb8755819452d0708"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "193ee314b7acf02f79f10f5ec41dcea5657503b12350f55b8277562003ed7a16"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab4e1dc2ca70a01c31b8d4c6b425db30074f801d9d2e07a5647ca13326908a7d"
    sha256 cellar: :any,                 arm64_linux:   "944fb7c16abb872110e42c243c294905690de548b51f83ca6c913be99e71c60c"
    sha256 cellar: :any,                 x86_64_linux:  "20158352612384f77833ee630c60e7878f1f9e7f13f320d984eda6df8709b68e"
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
