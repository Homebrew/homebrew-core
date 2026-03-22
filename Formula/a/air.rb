class Air < Formula
  desc "Fast and opinionated formatter for R code"
  homepage "https://github.com/posit-dev/air"
  url "https://github.com/posit-dev/air/archive/refs/tags/0.8.2.tar.gz"
  sha256 "2af13c1ce799a36b570920f47df89a9c5efb28646b706b08494ace5d13d903db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c031d79433c9bbe3ae1a5d99288f93cad4173f8ed6a0d81b176a4ac80b12f18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9a52f547fcfa63794a37cf19bc568d5a579100feb9112fa908c06ddeaf27f44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76755235356bb2f5805f9ce67a76a546db39a550cbd1637c361f03e7068caffe"
    sha256 cellar: :any_skip_relocation, sonoma:        "4aa3063dbc8583c6f1eb6df33a5f04e1693e06d09f2ef6e1901c93208944aae8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4339d1a841d0220bbff05edf68f3bfb93ff56cac92e4eba43152153ff54cb6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de19ca752ba456db18de08e6d850b775734a10724ad93bd45d6e590638b697a1"
  end

  depends_on "rust" => :build

  conflicts_with "go-air", because: "both install binaries with the same name"

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
