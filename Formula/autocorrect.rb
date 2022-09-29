class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://github.com/huacnlee/autocorrect"
  url "https://github.com/huacnlee/autocorrect/archive/v1.11.0.tar.gz"
  sha256 "6a2a8f82049be7c3dca51fb2d629c7ab565c09d1c32f0311b1ec7930bdb31163"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args(path: "autocorrect-cli")
  end

  test do
    (testpath/"autocorrect.md").write "Hello世界"
    out = shell_output("#{bin}/autocorrect autocorrect.md").chomp
    assert_equal "Hello 世界", out
  end
end
