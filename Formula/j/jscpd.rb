class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://jscpd.dev/"
  url "https://github.com/kucherenko/jscpd/archive/refs/tags/v5.0.11.tar.gz"
  sha256 "cff2bbc3a33c643cb5dcd2fd86c1f0f1187e617f6d05a529752e553d6cf7c945"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1e4ae12a82ed496d0ad77e44b4934115621ba046aed6302296dd36a6bca49c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b4e6e806237c22dc62ebfc45432fb9524427cd59199900cda1ccf889ceb7e93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df72623ed922d94ce8d259de3456a00819e4971f268ebe88fa54d20b656fa6c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e385934375bcef142a03040f37ae8121a89a837f9b498bee750e463a2352ea2"
    sha256 cellar: :any,                 arm64_linux:   "b97272095b8a9863e1be2063c95b3918b33498933a131c50a8d2747b5d74c46c"
    sha256 cellar: :any,                 x86_64_linux:  "b46df1b46850726397f9acb22d9ac8412b96f4edef75c25040c491d455dca72b"
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
