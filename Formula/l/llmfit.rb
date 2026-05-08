class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.22.crate"
  sha256 "4815e8fa53764feed9d096cf5499d67d5f57fd26d970c96e807c643941791fc3"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a60f709afdac20f956dfaa165da476c42ab10de69c8698fa948b01662bde3907"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a34ef9d73c8009dbfbc4df907f0d330fb8207d2a6d646357f2a0ed5e2807b4be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce508bef5023e304a1809fe2076c3e976857d382ed7a33ac9f381592380ab1d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "39b91169bc3dc3abdf5067744894d2d1410ca2434cf04bffb3701a9d0f3680f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3bc2ea99bac8d3eaa802d210b9f06a07f1d66ffaaa83f24d160d215ab5a30c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc299c28ff6ae3f1748e009ca971e6cf97fd50dc2ab04783a7d53cb4f5e62779"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models match", shell_output("#{bin}/llmfit info llama")
  end
end
