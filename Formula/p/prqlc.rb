class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/PRQL/prql/archive/refs/tags/0.13.7.tar.gz"
  sha256 "7bd4b7c220b46af8ec8c20a2c014323f4d884d1dd7f3dcf33e1e9352bb894f70"
  license "Apache-2.0"
  head "https://github.com/prql/prql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e5ec7b5bc0da73f3ed4ee328d3ab07eb0286722220de0f57ff148c5dcfc6762"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9011765fd6827e852b2f8efaa55ba2ac55d7d9fdb419a155df7fc2bedfd34328"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "beaa9ca2134ca6bff10c228455a78302e6e2211364f018d8b35ffda94997a077"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cb95346d70fdf08e78b242d3bea6135d19137f861ae1a8d370b606256ca0521"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7402fb2692cbde3fe5488faefd3196da6db92e3ee8ef2b560ee218e90b5778e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81182772334a0d09626cfa11b42c081392c4398d2b87792f5daf0264933aa788"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prqlc/prqlc")

    generate_completions_from_executable(bin/"prqlc", "shell-completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prqlc --version")

    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end
