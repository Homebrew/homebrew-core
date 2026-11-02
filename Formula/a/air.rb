class Air < Formula
  desc "Fast and opinionated formatter for R code"
  homepage "https://posit-dev.github.io/air/"
  url "https://github.com/posit-dev/air/archive/refs/tags/0.13.0.tar.gz"
  sha256 "2a7c8d7a64e0d2e7cb888e17266a8f543ac97831aa7c793d8378873dd109062f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "54799f29180cb8af194390ad8c54d5a8f0d81c1e8fecc7003e0f9764267874bb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a388de51b3c0ad79f3aa118791cc2fb06707cfa60387748e0ea26401dc28ff3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d5884da832cbc185e7fb510e69fd343c61638944e6fc1c7ce43277db84b991a2"
    sha256 cellar: :any,                 arm64_linux:       "fd02d5b43f6e16c3e71ce4a769c8fee38db4ca1b5df15c39904441d54bf84830"
    sha256 cellar: :any,                 x86_64_linux:      "2cfd97d1cb68eb888d6f04c8aa171eb46352b7da7be3315e83dc26f7c8ebc34c"
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
