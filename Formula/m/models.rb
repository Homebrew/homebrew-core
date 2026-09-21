class Models < Formula
  desc "Fast TUI and CLI for browsing AI models, benchmarks, and coding agents"
  homepage "https://reyamira.github.io/models/"
  url "https://github.com/reyamira/models/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "74361e3fde193772cd0db2ce4c9394487e437c4d7e416ebfafb0af661291d58a"
  license "MIT"
  head "https://github.com/reyamira/models.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "608cd26ee67e9fd73c8255db99394483a237ceffd06dc9ca1dadc4dfbbef72c4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "65438fd19e6cbcd13fbd7af709ace4794461cf5bda2ad70a7f9ea7f0e61bf658"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f7846c19f643d0e308239ed80491b0e23595994e47c6de25d9aceaa4c6f92311"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "c552925b33399f6942f7d5c5048fd898da17a68e998e91719aa2606016486258"
    sha256 cellar: :any,                 arm64_linux:       "6ab903439cd3f2cd30bad7c882eee87fc7b7d01c7f4f741a9ceab2a2d3b5c90c"
    sha256 cellar: :any,                 x86_64_linux:      "0a21bebea6960918efbad8f8538e8811520a9f50bca68a41c2f1abcfc11062ff"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/models --version")
    assert_match "claude-code", shell_output("#{bin}/models agents list-sources")
  end
end
