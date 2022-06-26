class Mailcheck < Formula
  desc "Check multiple mailboxes/maildirs for mail"
  homepage "https://mailcheck.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mailcheck/mailcheck/1.91.2/mailcheck_1.91.2.tar.gz"
  sha256 "6ca6da5c9f8cc2361d4b64226c7d9486ff0962602c321fc85b724babbbfa0a5c"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebfbf5a09b426cf879dc604f856b3512febfe7013bc74039dc35dcbf0d28b57e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cb8f491eff846164c8732bf372b323f8546830237ac097dc55dfba3747d6331"
    sha256 cellar: :any_skip_relocation, monterey:       "212f413b638cf5e1e95f27edec31f6f197cf4ff2f20d24e0580d7db1957b2ea6"
    sha256 cellar: :any_skip_relocation, big_sur:        "59d3c8716efff8670b81cec68c47b0663ffa079938ee6aae55078770564fa481"
    sha256 cellar: :any_skip_relocation, catalina:       "66fa586c21ec0cd9a842fcb99e8bbf822681c8858b864b14aa7d57ea89c47a99"
    sha256 cellar: :any_skip_relocation, mojave:         "7ea23945f9750c34d71ff05c5f41c0f5352e3eecaf1c7cf485d4f51096b9dd4e"
    sha256 cellar: :any_skip_relocation, high_sierra:    "c630704fee3dea86402e7486295a13601077bd991e45f23d3ac841c95a9c4474"
    sha256 cellar: :any_skip_relocation, sierra:         "8d33e3b08eef4dfaa7fa3d2c4e5f4a697cd2e5eb950c963f1f0845c0651da5ea"
    sha256 cellar: :any_skip_relocation, el_capitan:     "b7c134dc23431dfaa3f402b859b7154cab5e176711363bd884dc82ce896d7c7a"
    sha256 cellar: :any_skip_relocation, yosemite:       "242b05a6e9b8ccc1ac70e22cbf89bc33a885e726d32509fad6b34a3bee123945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84fa4f1d288f0f8824334bb68621b8589b65e0d9e21a4ca0961a33aae5d0ef63"
  end

  def install
    system "make", "mailcheck"
    bin.install "mailcheck"
    man1.install "mailcheck.1"
    etc.install "mailcheckrc"
  end
end
