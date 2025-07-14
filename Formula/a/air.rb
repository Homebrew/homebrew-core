class Air < Formula
  desc "Fast and opinionated formatter for R code"
  homepage "https://github.com/posit-dev/air"
  url "https://github.com/posit-dev/air/archive/refs/tags/0.7.0.tar.gz"
  sha256 "f33fc7aae6829f8471ca3b9144b0a314137393dc5423e10fa313a43278ffc6eb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95efa99526aeeb2732cbe5eb15f3ad9530a33f2c4493f20dc4c4e70157a50391"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33808ce6534f9ad19a635fa8d8d16facb3e591759b919dc25304e05f88c4116d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa9e723148a45dcc3c566241d4dbba0e504a9ad0506dd7fc022b7f2bda64073c"
    sha256 cellar: :any_skip_relocation, sonoma:        "550dec31a71701f7a342dba827b5672f216d8a87a9bd1143e492afaaf5638892"
    sha256 cellar: :any_skip_relocation, ventura:       "68de0b88299a6ca355cb1ec8103e20c043da1f954ae4b19f0c914794ec1c6b26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "424eb95cbea40473e47489dc73e6fb78478e34a412c57150485cd709162fd69a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d6d8c17739084e5fbb7aaf278adead841d7a66f8ca47b75f8bdd35b1a549755"
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
