class Getmail < Formula
  desc "Extensible mail retrieval system with POP3, IMAP4, SSL support"
  homepage "http://pyropus.ca/software/getmail/"
  url "http://pyropus.ca/software/getmail/old-versions/getmail-4.54.0.tar.gz"
  sha256 "d45657945353c68785b106dd9c5fae6bc2cec8f99fbb202d9dddd4967f483a65"

  bottle do
    cellar :any_skip_relocation
    sha256 "160d1c3504443e51a1ec9c85e7d1aac59b9fa2fded204fa023324618d213833e" => :sierra
    sha256 "37f222a5229a89983b0238748ea2828df9ac08eb87b0260feda54603fba572a0" => :el_capitan
    sha256 "8123f6f1a331902fab3ab427fad3e2c8f00277e54a8bfdcc081ce1053ae9ad1e" => :yosemite
    sha256 "db0a01b3ed8ecd7c8cd30fd929713d9ac3d2b24e18369dd526703b79e5c6492e" => :mavericks
  end

  def install
    libexec.install %w[getmail getmail_fetch getmail_maildir getmail_mbox]
    bin.install_symlink Dir["#{libexec}/*"]
    libexec.install "getmailcore"
    man1.install Dir["docs/*.1"]
  end

  test do
    system bin/"getmail", "--help"
  end
end
