class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/archive/v1.2.0.tar.gz"
  sha256 "17bd9413933ac34d86793c38578298c122835a85132b827fb2fc782b24034aef"
  head "https://github.com/lastpass/lastpass-cli.git"

  bottle do
    cellar :any
    sha256 "cf7e6c88785b3cb97f44d04a71050bc5439c928cc2615a49bf424acdd0ad56e9" => :sierra
    sha256 "5c5b99fc67efb6485e90515ae091b137457af11774f5b19804583f4985033c9a" => :el_capitan
    sha256 "f833cda5f0ff9faa495ee1aeb99cc77c07ee42fcd3d6baef249746f450b9b866" => :yosemite
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
