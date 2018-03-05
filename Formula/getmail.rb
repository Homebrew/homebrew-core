class Getmail < Formula
  desc "Extensible mail retrieval system with POP3, IMAP4, SSL support"
  homepage "http://pyropus.ca/software/getmail/"
  url "http://pyropus.ca/software/getmail/old-versions/getmail-5.5.tar.gz"
  sha256 "e0382ee59f1ec6ac2d6f01b71ca71db0826db0d267704b2bc2d97b9beda28350"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "504fc11caf6b211ede0d42cf2e9efcb1bee013228bc20bdb6e2265b1b54acf19" => :high_sierra
    sha256 "504fc11caf6b211ede0d42cf2e9efcb1bee013228bc20bdb6e2265b1b54acf19" => :sierra
    sha256 "504fc11caf6b211ede0d42cf2e9efcb1bee013228bc20bdb6e2265b1b54acf19" => :el_capitan
  end

  def install
    libexec.install %w[getmail getmail_fetch getmail_maildir getmail_mbox]
    inreplace Dir[libexec/"*"], %r{^#!/usr/bin/env python$}, "#!/usr/bin/python"
    bin.install_symlink Dir["#{libexec}/*"]
    libexec.install "getmailcore"
    man1.install Dir["docs/*.1"]
  end

  test do
    system bin/"getmail", "--help"
  end
end
