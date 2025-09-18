class Air < Formula
  desc "Fast and opinionated formatter for R code"
  homepage "https://github.com/posit-dev/air"
  url "https://github.com/posit-dev/air/archive/refs/tags/0.7.1.tar.gz"
  sha256 "627e29874b9e911a87cfd9086aef60445443c0fa886b014544c6e295a7051576"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27587f6a0250d1ff69a895d06388da5afbf21613cca8fd007636ccc00a119d7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d198da3991c6487fa90c0cf4ac1ee318e9b48268ef0fcd556cd270ad2c1e0cbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c14b6d040bab11f6171cadcc128f09117570d6c39d0b6802ff31f5c618133449"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c144c214c1c68f722004e57ebe69f873881847cf898c15fe585a19776caddb58"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a7be5ee231bf11ab97506a7531aa27a1fda1a4bc9deb4e05a180a045355530a"
    sha256 cellar: :any_skip_relocation, ventura:       "543712b3dfa6ad227d7767509721c80756afa6ba8dad39c789437fa4e8ce43b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23219932179b2aac3c848337dc63d23325a4ea4437db91881458a8701a415a78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6462f722d407498fca56f4ea8f38e46fee0913e3939ac2b469de513a26f83cdf"
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
