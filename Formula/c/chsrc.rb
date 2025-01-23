class Chsrc < Formula
  desc "Change Source for every software on every platform from the command-line"
  homepage "https://github.com/RubyMetric/chsrc"
  url "https://github.com/RubyMetric/chsrc/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "29ed92853355495561c238d19abd1df4f7336217ca576611c273c35c74175e37"
  license "GPL-3.0-or-later"
  head "https://github.com/RubyMetric/chsrc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fb55224200e74a6cbd0345a1cccd583f64a3b24418664586422fee2bb16bd0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aff6154136a890bb478a7d7c0b468bc06eaeb789fabce73a05afe25c399fe9a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8801a24bfcee5d9b813fd04c89094359136776ee22dcadfa4bd8854b2f1d17a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3fe5d32d07d638e25f0d00f51aed05a88144c69959ff402a1ba34c624a91e93"
    sha256 cellar: :any_skip_relocation, ventura:       "750620a10ceab6349edd948955bed55b182a6f4f4e2676e0209ff07c4469bd1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4c7f104abc446a5c5846d7b9b27c97932b9cb4951ca708fa9fc6ca4c1590cbd"
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
