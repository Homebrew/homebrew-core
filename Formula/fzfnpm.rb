class Fzfnpm < Formula
  desc "Fuzzy finder npm script runner"
  homepage "https://github.com/FrancisVega/fzfnpm"
  url "https://github.com/FrancisVega/fzfnpm/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "883cf5df0a76abbd22726609d8f516134e23350bfcb7fee5f2d29b1a5a0dc147"
  license "MIT"

  depends_on "bash"
  depends_on "fzf"

  def install
    bin.install "bin/fzfnpm"
  end

  test do
    # +x
    assert_predicate Pathname.new("#{bin}/fzfnpm"), :executable?
    # If no package.json in the same path, return with an message and code 1
    assert_match "No package.json file \u{1FAE5}\n", shell_output("#{bin}/fzfnpm", 1)
  end
end
