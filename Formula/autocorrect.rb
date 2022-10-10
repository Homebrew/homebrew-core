class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://github.com/huacnlee/autocorrect"
  url "https://github.com/huacnlee/autocorrect/archive/v2.1.1.tar.gz"
  sha256 "1367a2d6f2b8d034d54f0b92498900a6f2ba7b962c3ef374302d968617b3714d"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c269c95745482eb6a4e3561c268a661244afa6a7bb19688e052d470efa4bdb16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32e0ee8919f9365b76b83dc02aac5e249dfd1a1d54ccea49be71a1404aa3b835"
    sha256 cellar: :any_skip_relocation, monterey:       "1906e86102ec435a817a14c36acea87b07805b9a1d1e0d1bc9ac84033d14f513"
    sha256 cellar: :any_skip_relocation, big_sur:        "b22b78f344c70f4c34892a493d6e518cd0b8e1bde4c4d7d46c0f2a452edaa4a6"
    sha256 cellar: :any_skip_relocation, catalina:       "fa985e804f51fbd2e41c213ba1608f7b7307f99785a062c96cffd9b58c674944"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca34b3f7318fff77c53f2cadef567376c6248da19430aa46eedc85fdfa43ef36"
  end

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
