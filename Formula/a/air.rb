class Air < Formula
  desc "Fast and opinionated formatter for R code"
  homepage "https://github.com/posit-dev/air"
  url "https://github.com/posit-dev/air/archive/refs/tags/0.8.1.tar.gz"
  sha256 "5d3f445ab046a2765a279eb33f296d091eb783a73d6f9da220294c5298b263d8"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "078dd37959d207d294fdfd5619c22d40190048caee0e355f9b436cd8f7810904"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66be0d37d7e424ef885fdbb14f0883cb98d0f3d3cb703994d3fda5242a250fc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35922c152779f31d53d57e2644fe098561f0056cfb579529c95c3539c8f3b4e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "e12336b3f00141c4fba4e2e0e24122faaf1a0774173185cb1d8bdcdff193c92a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "100a438291a034863c8bad0973fcebc8cb1cca067ede14ddb7094fa6277bfe16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f35e9759f3e71135b1865a1f7588ac020c67ad728a9d2349543312c0ea1c9ba8"
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
