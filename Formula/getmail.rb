class Getmail < Formula
  desc "Extensible mail retrieval system with POP3, IMAP4, SSL support"
  homepage "http://pyropus.ca/software/getmail/"
  url "http://pyropus.ca/software/getmail/old-versions/getmail-4.49.0.tar.gz"
  sha256 "1c6c4a3ebd17c1b15dc940a5888b0ceca4d135c1c20629ebe274ba025aff1ed4"

  bottle do
    cellar :any_skip_relocation
    sha256 "160d1c3504443e51a1ec9c85e7d1aac59b9fa2fded204fa023324618d213833e" => :sierra
    sha256 "37f222a5229a89983b0238748ea2828df9ac08eb87b0260feda54603fba572a0" => :el_capitan
    sha256 "8123f6f1a331902fab3ab427fad3e2c8f00277e54a8bfdcc081ce1053ae9ad1e" => :yosemite
    sha256 "db0a01b3ed8ecd7c8cd30fd929713d9ac3d2b24e18369dd526703b79e5c6492e" => :mavericks
  end

  # See: https://github.com/Homebrew/homebrew/pull/28739
  patch do
    url "https://gist.githubusercontent.com/sigma/11295734/raw/5a7f39d600fc20d7605d3c9e438257285700b32b/ssl_timeout.patch"
    sha256 "cd5efe16c848c14b8db91780bf4e08a5920f6576cc68628b0941aa81857f4e2f"
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
