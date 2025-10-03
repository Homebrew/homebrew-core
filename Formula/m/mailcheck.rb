class Mailcheck < Formula
  desc "Check multiple mailboxes/maildirs for mail"
  homepage "https://mailcheck.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mailcheck/mailcheck/1.91.2/mailcheck_1.91.2.tar.gz"
  sha256 "6ca6da5c9f8cc2361d4b64226c7d9486ff0962602c321fc85b724babbbfa0a5c"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c8e59c981638d71fa3e78a9998b696e677189346da07f918bc290752c289f1dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9826a29c8ea6cc9f8a3c2c1a85c39726d0412898ab38feccdc027ccf505a5662"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5892072eefc7d2c38a7acabbb05bb380943380d11e46ea2c6f514abe08979184"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa14d797b2b2de01428e52e56c0e26ffe36d72227393ec4554c0749b8189aa60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebfbf5a09b426cf879dc604f856b3512febfe7013bc74039dc35dcbf0d28b57e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cb8f491eff846164c8732bf372b323f8546830237ac097dc55dfba3747d6331"
    sha256 cellar: :any_skip_relocation, sonoma:         "193fcd7805d976190391ae4bcf34afd28ebd82bfd45aff54c307aa6325a7a93f"
    sha256 cellar: :any_skip_relocation, ventura:        "d6e91d19af4b560df0f8a4c02dc922e7e31273812076b8d326109f394a8d7dbf"
    sha256 cellar: :any_skip_relocation, monterey:       "212f413b638cf5e1e95f27edec31f6f197cf4ff2f20d24e0580d7db1957b2ea6"
    sha256 cellar: :any_skip_relocation, big_sur:        "59d3c8716efff8670b81cec68c47b0663ffa079938ee6aae55078770564fa481"
    sha256 cellar: :any_skip_relocation, catalina:       "66fa586c21ec0cd9a842fcb99e8bbf822681c8858b864b14aa7d57ea89c47a99"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f1c3ac175abf729a56d77e55d0039cafe7f478c9e069961a8383f1b2c6f1e963"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84fa4f1d288f0f8824334bb68621b8589b65e0d9e21a4ca0961a33aae5d0ef63"
  end

  def install
    system "make", "mailcheck"
    bin.install "mailcheck"
    man1.install "mailcheck.1"
    etc.install "mailcheckrc"
  end
end
