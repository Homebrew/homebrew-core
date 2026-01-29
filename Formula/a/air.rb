class Air < Formula
  desc "Fast and opinionated formatter for R code"
  homepage "https://github.com/posit-dev/air"
  url "https://github.com/posit-dev/air/archive/refs/tags/0.8.1.tar.gz"
  sha256 "5d3f445ab046a2765a279eb33f296d091eb783a73d6f9da220294c5298b263d8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50c8d275e751ca5ea4ce9f09c1086d67a68e0c19af1dedcc8fa77a26e20c0973"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9662db912578844579fc7ad0d13161c147cf1e020dfe304e20db932f7cf3c926"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a15f6087e2cb369ff3424b9cb8500ff6fade33e298075f11bdaff11ed1d8fec6"
    sha256 cellar: :any_skip_relocation, sonoma:        "3054333b1a65cc2aee65464dc04c695de43f86f7213f0206a3049b0e85907ccc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "328a0708468d6d91273ca36a3495ab860af89ff263c0c1783e8badb5591415dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30d1f6723c09bab69478fb67362f19515f2a5f6bc19c55798235a19e78742816"
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
