class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://huacnlee.github.io/autocorrect/"
  url "https://github.com/huacnlee/autocorrect/archive/refs/tags/v2.16.3.tar.gz"
  sha256 "cb7d0f070127f02f35fbcecc67c674b032eee617a0f84b5292d54e761e944538"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97083d441c65f09edcb3837ad336e449656c512606f03c644f9c8a7a1e606226"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e688cb8f8655d64a90fe09e647ddb0670debcd0f31a51112caf2107497983654"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc3c3463db4134ba4f19212e9ad56f94b018090536424121a81c33f4807f4878"
    sha256 cellar: :any_skip_relocation, sonoma:        "970e03abc43df9fcbfd8888e113c1fa44b34bcd3da5db3a1ec361f3fe5f41907"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc0c738d58c9bc20119fcd7f5114a06fa6f66b73fe7c8dbb201037185806b69a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10f0c2f1cb081edda8e9c4f1da2794484ba1ccea18722c2ae3aeade46cdf6185"
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
