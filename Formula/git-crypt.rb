class GitCrypt < Formula
  desc "Enable transparent encryption/decryption of files in a git repo"
  homepage "https://www.agwa.name/projects/git-crypt/"
  url "https://www.agwa.name/projects/git-crypt/downloads/git-crypt-0.6.0.tar.gz"
  sha256 "6d30fcd99442d50f4b3c8d554067ff1d980cdf9f3120ee774131172dba98fd6f"
  revision 1

  bottle do
    cellar :any
    sha256 "f38bb645c3eff62cfb43802199370d85e4785fcf10c063e4d7453e032788bcba" => :catalina
    sha256 "89d2058a4dd5afc565696707c8e93621fd644f9ab303fe378727ae999783d156" => :mojave
    sha256 "0d2cf3c93ab2ca4059163f8da8a3ab845b566b13debf5e1b43a734dc86138a18" => :high_sierra
    sha256 "6b2c2773e5c327282d461f5d49600928ae97d432e5f4d8b7acfcaaa6e6d1ef68" => :sierra
  end

  depends_on "openssl@1.1"

  def install
    system "make"
    bin.install "git-crypt"
  end

  test do
    system "#{bin}/git-crypt", "keygen", "keyfile"
  end
end
