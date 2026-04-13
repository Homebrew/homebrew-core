class Air < Formula
  desc "Fast and opinionated formatter for R code"
  homepage "https://github.com/posit-dev/air"
  url "https://github.com/posit-dev/air/archive/refs/tags/0.9.0.tar.gz"
  sha256 "55cae527153badeb348b7b04ffb3c9f1d9f20e27e388edeae694a05a5e32f289"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3cdb70245f6c433f14ccf5c6a3e473211d841d68e866c075482a5aac84924220"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d3f08bac31302ae24da92a96b36c52ee646308bd22fb1e43af535d2961f937d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21354f33670a2f68b622df816b7f5aa63e39ba59a87ef770834f1e621023c10a"
    sha256 cellar: :any_skip_relocation, sonoma:        "006fb173fa272b8659f87e98a7ac5bbba08025ab25bdd95e71db012721563d05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09795b0dd31cc71c4f8a352c9632fce9a0011cfbf1406ec6705c6d5f6bfc06db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "038cdad4a0b237a93301ec63bf275466cd43e3fc354c79aae2898aa6f0fb34f3"
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
