class Getmail < Formula
  desc "Extensible mail retrieval system with POP3, IMAP4, SSL support"
  homepage "http://pyropus.ca/software/getmail/"
  url "http://pyropus.ca/software/getmail/old-versions/getmail-5.13.tar.gz"
  sha256 "04d52f6475f09e9f99b4e3d2f1d2eb967a68b67f09af2a6a5151857f060b0a9d"

  bottle do
    cellar :any_skip_relocation
    sha256 "087dfb1285595c973190bf3d8d61e88823b3bc59375f2d2b001e315d2ebcb449" => :mojave
    sha256 "e68ba106188d5de7ba03e4cc6335eb920b8fae875770fd33ec9c7f13f6cc25ac" => :high_sierra
    sha256 "e68ba106188d5de7ba03e4cc6335eb920b8fae875770fd33ec9c7f13f6cc25ac" => :sierra
    sha256 "e68ba106188d5de7ba03e4cc6335eb920b8fae875770fd33ec9c7f13f6cc25ac" => :el_capitan
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
