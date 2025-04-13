class IsFast < Formula
  desc "Check the internet as fast as possible"
  homepage "https://github.com/Magic-JD/is-fast"
  url "https://github.com/Magic-JD/is-fast/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "58d8a6cca7d5c0355c13206d6028aad06dc3e6885f895edcaaa663726e7f51ba"
  license "MIT"
  head "https://github.com/Magic-JD/is-fast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21b2ab2138232bb5d6100ec9e09179b2a4924bfc76311b0fc405cf81e98cdf24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ec782570b6770cfb22598d937aa0d7d38d279be00052ae55926132bf6e16c5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce4fc48b576a3d248cd1215f3b1e3d36eae212234420d18bf51abb431a28ff03"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb41975c4adea241c48c4601ab8e75654e6ab35c1ea142ef612f78a06b18b662"
    sha256 cellar: :any_skip_relocation, ventura:       "c2c3aa63b2fcdb808549fa2bdbcb1d09c7b136bc1f77a361eae30323427b03ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9337afcc9e8add222f0fe2c1aa1ae664a0187fc3550e2b11121d9062e1b214b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "292f629419e2a70d50c3f73f639bcfd7a205aae2da49b4abf8097ebb4716a1f1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "is-fast #{version}", shell_output("#{bin}/is-fast --version")

    (testpath/"test.html").write <<~HTML
      <!DOCTYPE html>
      <html>
        <head><title>Test HTML page</title></head>
        <body>
          <p>Hello Homebrew!</p>
        </body>
      </html>
    HTML

    assert_match "Hello Homebrew!", shell_output("#{bin}/is-fast --piped --file #{testpath}/test.html")
  end
end
