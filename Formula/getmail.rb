class Getmail < Formula
  desc "Extensible mail retrieval system with POP3, IMAP4, SSL support"
  homepage "http://pyropus.ca/software/getmail/"
  url "http://pyropus.ca/software/getmail/old-versions/getmail-5.13.tar.gz"
  sha256 "04d52f6475f09e9f99b4e3d2f1d2eb967a68b67f09af2a6a5151857f060b0a9d"

  bottle do
    cellar :any_skip_relocation
    sha256 "bbdb94c93d8c1371b5b711d0ad5e7d93291bf258c9369db8cf86df21b93730d9" => :mojave
    sha256 "bbdb94c93d8c1371b5b711d0ad5e7d93291bf258c9369db8cf86df21b93730d9" => :high_sierra
    sha256 "b7a29273d7246e00f25c029b887c64cec4d2db89613de17ba48c76031c5116e7" => :sierra
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
