class Getmail < Formula
  desc "Extensible mail retrieval system with POP3, IMAP4, SSL support"
  homepage "http://pyropus.ca/software/getmail/"
  url "http://pyropus.ca/software/getmail/old-versions/getmail-4.54.0.tar.gz"
  sha256 "d45657945353c68785b106dd9c5fae6bc2cec8f99fbb202d9dddd4967f483a65"

  bottle do
    cellar :any_skip_relocation
    sha256 "b3100ee5adc9cceeff6e29185032cfc98b29f3780b79b75a4058985fec9722a7" => :sierra
    sha256 "b3100ee5adc9cceeff6e29185032cfc98b29f3780b79b75a4058985fec9722a7" => :el_capitan
    sha256 "b3100ee5adc9cceeff6e29185032cfc98b29f3780b79b75a4058985fec9722a7" => :yosemite
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
