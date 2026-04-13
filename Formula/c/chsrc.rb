class Chsrc < Formula
  desc "Change Source for every software on every platform from the command-line"
  homepage "https://github.com/RubyMetric/chsrc"
  url "https://github.com/RubyMetric/chsrc/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "4fc7ccbdea9c18aaa06b1efc80cc8a1941e38060b8495c67c947a09d2a0dfeac"
  license "GPL-3.0-or-later"
  head "https://github.com/RubyMetric/chsrc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0319a43c6289df4d83667e517fe54dd39c58c4d6486f379a3092461a36550f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bf31b588fd5675b656b5c55c33124325508dd4412f4e6f161f3bb8c1a5776d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f7d072ffd55e02f99c26e5e24a340f6d5ad12ff8192be0d5a3c87486bc51b54"
    sha256 cellar: :any_skip_relocation, sonoma:        "83241be9635b64cf7217cbfb7d99185e7b0e58caa2a595ef5bf6200fcc2952bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ee3a48a02b5f98db6ef8b78f90cf5490fe6a5f07169b57d9df250eaf6a196fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "affc34ed5945c691524868219ef73d1a912fb20e65564efbaca58859fb81f727"
  end

  def install
    system "make"
    bin.install "chsrc"
  end

  test do
    assert_match(/mirrorz\s*MirrorZ.*MirrorZ/, shell_output("#{bin}/chsrc list"))
    assert_match version.to_s, shell_output("#{bin}/chsrc --version")
  end
end
