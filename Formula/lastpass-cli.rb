class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/archive/v1.2.1.tar.gz"
  sha256 "1a49a37a67a973296e218306e6d36c9383347b1833e5a878ebc08355b1c77456"
  head "https://github.com/lastpass/lastpass-cli.git"

  bottle do
    cellar :any
    sha256 "fabd40b9ebc0b6ecf2cf01b49f9e5329a5aafdb1671b6931d7f6e482468a65fc" => :high_sierra
    sha256 "977ecddba6a0f822242e0a96add0639f5ea0a1467a0618025771b66684a823fb" => :sierra
    sha256 "2082cc3a425a5f9bd4f8338b1e891160e25a7d1df51f0de0488aab292c72f1a5" => :el_capitan
    sha256 "710ae68c279e7fa9f63a4c79c4137448e1d00b14f5cb5885cc09da41e6fee22e" => :yosemite
  end

  depends_on "asciidoc" => :build
  depends_on "cmake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "pinentry" => :optional

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "make", "PREFIX=#{prefix}", "install"
    system "make", "MANDIR=#{man}", "install-doc"
  end

  test do
    system "#{bin}/lpass", "--version"
  end
end
