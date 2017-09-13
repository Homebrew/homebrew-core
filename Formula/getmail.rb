class Getmail < Formula
  desc "Extensible mail retrieval system with POP3, IMAP4, SSL support"
  homepage "http://pyropus.ca/software/getmail/"
  url "http://pyropus.ca/software/getmail/old-versions/getmail-5.1.tar.gz"
  sha256 "3d6e20e5ea41c1ffb284a46de3d2a474bf2ebd9215441c4c379183d03710027e"

  bottle do
    cellar :any_skip_relocation
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
