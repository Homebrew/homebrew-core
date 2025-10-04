class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://huacnlee.github.io/autocorrect/"
  url "https://github.com/huacnlee/autocorrect/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "faf6f0940e2e5184a0db0c41b6abb7565e0e2ffab292fc77c4d3affd4771f634"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4eff2fcecb6ac2419cd4fe9b94846d4a5c0cf9eb2034daede8b46e93325c7fbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0347e98f52ecb8a040955df02b6ec01416fb77fadb79e91fb540202802213a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "720632693d85ed3eb37ee23bb4b74244635a6a9a7bd4a195e71e6c4055fe9ac5"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa9210ff9813f627718acdb6cd8d0275d982a2790b896fac232207a63d7a0cd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56fa8ed46c7d020f50cd2f4cd711899b2d8d9fd9b7042d9a8e67b4ec5b6c01df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c6d7e0512b4682eefd063d67cb4e656643426d9df1dfc15de06cfd567de559d"
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
