class Air < Formula
  desc "Fast and opinionated formatter for R code"
  homepage "https://posit-dev.github.io/air/"
  url "https://github.com/posit-dev/air/archive/refs/tags/0.11.0.tar.gz"
  sha256 "07ce82c3200296afca23efdbc9aae1943c4d0b6dfd5aa3fa47353dd709dff648"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe24773c57236eb5e15a7866185f11961f17b1f63830c029a0f5e8a1a14b33fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d06c1ec27ce2c8e58c555014b5518201f39e49fcbb7d60bfd5325f624afd74c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0fd2e24c4886fca0baa0faf78d7e1da9438f2498f084cdd89dabfad8d77d637"
    sha256 cellar: :any_skip_relocation, sonoma:        "5df4891be551c21c65a8bbc6579be7ce4acefa9c161f1f64c53853da5426a2fd"
    sha256 cellar: :any,                 arm64_linux:   "5a521a49c5a2fef3999d8f9b3c3a281743ea5150bd3be98c0f4912947a258162"
    sha256 cellar: :any,                 x86_64_linux:  "0de3fde42a0cd0d489dc3fd643a7e7924da954ca4c537a7479b390cf02f52f96"
  end

  depends_on "rust" => :build

  conflicts_with "go-air", because: "both install binaries with the same name"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/air")

    generate_completions_from_executable(bin/"air", "generate-shell-completion", shells: [:bash, :zsh, :fish, :pwsh])
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
