class Mailcheck < Formula
  desc "Check multiple mailboxes/maildirs for mail"
  homepage "https://mailcheck.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mailcheck/mailcheck/1.91.2/mailcheck_1.91.2.tar.gz"
  sha256 "6ca6da5c9f8cc2361d4b64226c7d9486ff0962602c321fc85b724babbbfa0a5c"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ea23945f9750c34d71ff05c5f41c0f5352e3eecaf1c7cf485d4f51096b9dd4e" => :mojave
    sha256 "c630704fee3dea86402e7486295a13601077bd991e45f23d3ac841c95a9c4474" => :high_sierra
    sha256 "8d33e3b08eef4dfaa7fa3d2c4e5f4a697cd2e5eb950c963f1f0845c0651da5ea" => :sierra
    sha256 "b7c134dc23431dfaa3f402b859b7154cab5e176711363bd884dc82ce896d7c7a" => :el_capitan
    sha256 "242b05a6e9b8ccc1ac70e22cbf89bc33a885e726d32509fad6b34a3bee123945" => :yosemite
    sha256 "32b40cf41ec15bcd0efbfb90858534e4b84056915ceacd6914d71d8acdffeb6f" => :mavericks
  end

  def install
    system "make", "mailcheck"
    bin.install "mailcheck"
    man1.install "mailcheck.1"
    etc.install "mailcheckrc"
  end
end
