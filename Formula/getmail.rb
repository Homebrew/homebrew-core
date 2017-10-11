class Getmail < Formula
  desc "Extensible mail retrieval system with POP3, IMAP4, SSL support"
  homepage "http://pyropus.ca/software/getmail/"
  url "http://pyropus.ca/software/getmail/old-versions/getmail-5.4.tar.gz"
  sha256 "ba896f7b3fbae4e9e79f7135e6c2b10b281170d2877b91fb2b265c927ed29ac7"

  bottle do
    cellar :any_skip_relocation
    sha256 "1fb642974520e619530d5acfaaf442e44b3f4c21c6bad41615002b96defa8ec3" => :high_sierra
    sha256 "15010d3a831c771346c2e5b1c85071df1d5b49fd9d8d36b2b79bc927c7716c95" => :sierra
    sha256 "15010d3a831c771346c2e5b1c85071df1d5b49fd9d8d36b2b79bc927c7716c95" => :el_capitan
    sha256 "15010d3a831c771346c2e5b1c85071df1d5b49fd9d8d36b2b79bc927c7716c95" => :yosemite
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
