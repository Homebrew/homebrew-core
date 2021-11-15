class ImessageRuby < Formula
  desc "Command-line tool to send iMessage"
  homepage "https://github.com/linjunpop/imessage"
  url "https://github.com/linjunpop/imessage/archive/v0.3.1.tar.gz"
  sha256 "74ccd560dec09dcf0de28cd04fc4d512812c3348fc5618cbb73b6b36c43e14ef"
  license "MIT"
  head "https://github.com/linjunpop/imessage.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cb42cee42f6011f5a9d7489b35750f2fb2edca3cf1f77fb224de3befc80615bb"
    sha256 cellar: :any_skip_relocation, big_sur:       "f04a68762e8c942003c8b0c2b1470e51d9de5f2f6e5827abd4b660b392bcf3ce"
    sha256 cellar: :any_skip_relocation, catalina:      "64987077d2b09f6c2fc5f88161514d1ce988d44baa5b622a41192cad72982b3b"
    sha256 cellar: :any_skip_relocation, mojave:        "ae557de18880f38b34b4e47046b6c1d72d135167c10a1250479c575b3a6747fb"
    sha256 cellar: :any_skip_relocation, high_sierra:   "e287b21ce1694d5ec9c5376fb142232b2df72fb907b12cb5b0ff22bd2fc04ab2"
    sha256 cellar: :any_skip_relocation, sierra:        "446892e091382593a46ee69b8fb01354f1cc363a97b8a967332553a577bab8f6"
    sha256 cellar: :any_skip_relocation, el_capitan:    "0e7fd4f055a6ba4e81273a5952504ceb74b835387c144a24e61f020e55e6018e"
    sha256 cellar: :any_skip_relocation, yosemite:      "1024e6cee26ed9fc8ae4ef1941edc64d0e6d16006bd2a530d5644e7c00f8a350"
    sha256 cellar: :any_skip_relocation, all:           "0b7458ee03125b10dcf7a59d60b7cd99bf4e770304e98ecd6a37298705d4b9f0"
  end

  depends_on :macos

  def install
    system "rake", "standalone:install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/imessage", "--version"
  end
end
