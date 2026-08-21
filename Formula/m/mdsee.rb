class Mdsee < Formula
  desc "Markdown viewer for your terminal"
  homepage "https://docs.rs/crate/mdsee/0.1.0"
  url "https://static.crates.io/crates/mdsee/mdsee-0.1.0.crate"
  sha256 "7bb393fdcbb2382ba930e5c507d4cc3bddec7b1734265d2cd44f6e502175ebbf"
  license "MIT"
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdsee --version")

    input = testpath/"test.md"
    input.write("# mdsee\n")
    assert_match "mdsee", shell_output("#{bin}/mdsee #{input}")
  end
end
