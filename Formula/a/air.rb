class Air < Formula
  desc "Fast and opinionated formatter for R code"
  homepage "https://github.com/posit-dev/air"
  url "https://github.com/posit-dev/air/archive/refs/tags/0.8.0.tar.gz"
  sha256 "fbce4a9698c756dc4d65eb6cb845fcdd8bca952f25b988711037b6ff9b82a99c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22bfc11080f588ebe147ee1eff7e54c62f2c5fb0aa9334aa29041a1211ca2fea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6237dee64f4f22f034686e091ccdf7adca3452ff59118d6b9167eaef4ca06c62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41aafa386238de558ba5c1050c5931ebaae5372548ed6632340ebecc9c0e5324"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bfb9ac82a1d126386b1bb3dccb55cea3d4385d030f0c443eb7b578d30bef4dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28d2350eb72cf1f61922bf5a32340fcd821a88d32995d2052e1d3513ed9fbb96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5b74bd49dfb4b972e2624a666f97c20611634bfe0990d516b1621ee1fab84c3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/air")
  end

  test do
    (testpath/"test.R").write <<~R
      # Simple R code for testing
      x<-1+2
      y <- 3 + 4
      print(x+y)
    R

    assert_match "air #{version}", shell_output("#{bin}/air --version")

    system bin/"air", "format", testpath/"test.R"

    formatted_content = (testpath/"test.R").read
    assert_match "x <- 1 + 2", formatted_content
    assert_match "y <- 3 + 4", formatted_content
  end
end
