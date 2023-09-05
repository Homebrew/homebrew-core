class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://github.com/huacnlee/autocorrect"
  url "https://github.com/huacnlee/autocorrect/archive/v2.8.4.tar.gz"
  sha256 "e176fe00e2890e499e48fec4412142f2f3f4f799ce6d348b5492d65759b1d2f8"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94ffccd8e930262e010233ccf5b2d2ee10171e61cfd8fedfa5b572294283592e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ecb551c917d3fa363c7af8819dc034f9886608e869ec86bbe1b58bbd7e080c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88789d8d03bba5e3b3f11c81a85a9e61b8d7d86ab5031d728e730b55da4b0c29"
    sha256 cellar: :any_skip_relocation, ventura:        "a53ae80ce71ee7afced96ea08945857e455469978ff9460a9a61afd7bb1789ea"
    sha256 cellar: :any_skip_relocation, monterey:       "257e2e27727c4d9b009ce2a603193aecc04b0689f9d7bb8f1112018ee924275f"
    sha256 cellar: :any_skip_relocation, big_sur:        "94d82168bae776874f0e2bcbf103389c536edb93c1baa323109ab4b0881fd4be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a828d198d2ca2ce1e9cc1ef4e66d477a969a7c04b8d33827eb0756477ce72083"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "autocorrect-cli")
  end

  test do
    (testpath/"autocorrect.md").write "Hello世界"
    out = shell_output("#{bin}/autocorrect autocorrect.md").chomp
    assert_equal "Hello 世界", out
  end
end
