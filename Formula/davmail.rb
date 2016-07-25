class Davmail < Formula
  desc "POP/IMAP/SMTP/Caldav/Carddav/LDAP exchange gateway"
  homepage "http://davmail.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/davmail/davmail/4.7.2/davmail-4.7.2-2427.zip"
  sha256 "1c08bb97e08e1d29bee9bab0a58c70ef975c2f98bb91354c4ab3da283462823c"

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"davmail.jar", "davmail"
  end
end
