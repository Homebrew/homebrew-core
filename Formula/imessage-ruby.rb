class ImessageRuby < Formula
  desc "Command-line tool to send iMessage"
  homepage "https://github.com/linjunpop/imessage"
  url "https://github.com/linjunpop/imessage/archive/v0.3.1.tar.gz"
  sha256 "74ccd560dec09dcf0de28cd04fc4d512812c3348fc5618cbb73b6b36c43e14ef"
  head "https://github.com/linjunpop/imessage.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e287b21ce1694d5ec9c5376fb142232b2df72fb907b12cb5b0ff22bd2fc04ab2" => :high_sierra
    sha256 "446892e091382593a46ee69b8fb01354f1cc363a97b8a967332553a577bab8f6" => :sierra
    sha256 "0e7fd4f055a6ba4e81273a5952504ceb74b835387c144a24e61f020e55e6018e" => :el_capitan
    sha256 "1024e6cee26ed9fc8ae4ef1941edc64d0e6d16006bd2a530d5644e7c00f8a350" => :yosemite
    sha256 "7b546ccf5cf13a7d474c635a57eebc8e74ff61ea6c7c3cdfefffe4c78737ab47" => :mavericks
  end

  depends_on :macos => :mavericks

  def install
    system "rake", "standalone:install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/imessage", "--version"
  end
end
