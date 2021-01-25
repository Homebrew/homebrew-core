class Getmail < Formula
  desc "Extensible mail retrieval system with POP3, IMAP4, SSL support"
  homepage "http://pyropus.ca/software/getmail/"
  url "http://pyropus.ca/software/getmail/old-versions/getmail-5.15.tar.gz"
  sha256 "d453805ffc3f8fe2586ee705733bd666777e53693125fdb149494d22bd14162a"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?getmail[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e3481bec43a52377745e09fe62324f4daa35964f862150b23ba8044a6a85eeca" => :big_sur
    sha256 "6c2efe9061839c88f5041cb06a8a9d5aeb8681f57d0f82d889725239b5b14ec6" => :arm64_big_sur
    sha256 "a69c9ebda4863ac97ea2259b007d15a4024b7af75912fca0ef9f39cbe972ba8f" => :catalina
    sha256 "c729f338af43aebe206c4b0cbddebd1d1619d94a8277e4f1dc43908fba631b8b" => :mojave
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
