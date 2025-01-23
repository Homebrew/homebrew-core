class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://huacnlee.github.io/autocorrect/"
  url "https://github.com/huacnlee/autocorrect/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "4848b672a779a67c0649098ba5ff58cd89dd69bd3bc8bda159889190971ced76"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "126c4443939b2cef7e021ad75e5d804fd50dd7774838fc8b0942c4504a5e3d60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "044aa971fccd7031d76d25d136985458c48ced2783896ce44f5925de0b042df1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "770f65cacce8ca073d71dbd8ae467a4ca3eee7534fe3bc0344501d71c804864c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e7c3abed394d0786f1f03f30943db6a0b488a7bd28fc9db62645a878ed7135c"
    sha256 cellar: :any_skip_relocation, ventura:       "38a657d539fef5f0f2e0e09adabbc41ed57a8eb16fcbcd9a33a00b8814521315"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5123a57f0663c808a602c82aa4e4055c160e06270dbc28b2637daf2c1c840261"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "autocorrect-cli")
  end

  test do
    (testpath/"autocorrect.md").write "Hello世界"
    out = shell_output("#{bin}/autocorrect autocorrect.md").chomp
    assert_match "Hello 世界", out

    assert_match version.to_s, shell_output("#{bin}/autocorrect --version")
  end
end
