class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/archive/v1.1.1.tar.gz"
  sha256 "1aac80da5305a73d6574892c9948078fcbfb0fa25c0e1b29712659de64273243"
  head "https://github.com/lastpass/lastpass-cli.git"

  bottle do
    cellar :any
    sha256 "5a28248885da75621bfcb78aaee4c1fc99eb2e0f14f0c0a974f0b099fa7b2c54" => :sierra
    sha256 "f74caf7d2c500146bc08b771f24edcb9e68cc54638110eaa5ae54877b50b8274" => :el_capitan
    sha256 "1c6dc1b0bee7527f946f28f4f625eb8d11c13887c31ea00fd7afc8f324803224" => :yosemite
  end

  depends_on "asciidoc" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "pinentry" => :optional

  def install
    system "make", "PREFIX=#{prefix}", "install"
    system "make", "MANDIR=#{man}", "install-doc"
  end

  test do
    system "#{bin}/lpass", "--version"
  end
end
