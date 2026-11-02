class Air < Formula
  desc "Fast and opinionated formatter for R code"
  homepage "https://posit-dev.github.io/air/"
  url "https://github.com/posit-dev/air/archive/refs/tags/0.13.0.tar.gz"
  sha256 "2a7c8d7a64e0d2e7cb888e17266a8f543ac97831aa7c793d8378873dd109062f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bcecbad2270a620ae7f9c4e7828111eff44b23d3f8c185b8128e4c8da1008ebe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a7563ed37a53433095ba207b03738dba62b70f40dd3eaf48a2cdbbe55d499dda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8f5363c786a1e19e6f3235939b30f0bb7fdcaedc5062db904e7673dccbe53294"
    sha256 cellar: :any,                 arm64_linux:       "1916044aed3b838fe99090df7220db08fd922f3ba5bca24e6a48aec703f6bd88"
    sha256 cellar: :any,                 x86_64_linux:      "c6be0fe99691dfb5475a1f1a51ce1db7988785d70924a71a47bdef3bbd7ffbbb"
  end

  depends_on "rust" => :build

  conflicts_with "go-air", because: "both install binaries with the same name"

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

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

    assert_match version.to_s, shell_output("#{bin}/air --version")

    system bin/"air", "format", testpath/"test.R"

    formatted_content = (testpath/"test.R").read
    assert_match "x <- 1 + 2", formatted_content
    assert_match "y <- 3 + 4", formatted_content
  end
end
