class Air < Formula
  desc "Fast and opinionated formatter for R code"
  homepage "https://posit-dev.github.io/air/"
  url "https://github.com/posit-dev/air/archive/refs/tags/0.10.0.tar.gz"
  sha256 "4ef28a95df9c037aa6bdb9b36f94dcdcdbb64b469e49729268e2921d6d2e1968"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "501f12023c37dfc553e311e833f84561351d331f4a34ea7dde000f5f228c27cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2623234f9b3220ab05b9403ace827550664f390a039e9e1184fc146896bc206"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5121c64eb4250690007a0695ca599052e7fb051b18461fa3feeb5df685e8de1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2fea279afc4f5584949d94380f8e0f8650e4eb2627a2d86a75b1301fb5f5262"
    sha256 cellar: :any,                 arm64_linux:   "688979f75d2951dd7826eb2c03f1a8ee1871d52b1848a484142d0bac43661cab"
    sha256 cellar: :any,                 x86_64_linux:  "0ac9a0c7b733ae07052cf5d33506d73e49a134e254a738dab807fe40624dde57"
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
