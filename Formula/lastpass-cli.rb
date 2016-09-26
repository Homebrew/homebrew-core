class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/archive/v1.0.0.tar.gz"
  sha256 "42096c0bd3972b0e9cc9cef32fbf141e47b04b9e2387fb3abe8b105e135fb41e"
  head "https://github.com/lastpass/lastpass-cli.git"

  bottle do
    cellar :any
    sha256 "bc5e958d0b2529ab05e78dfbecd332ddb7f2b061ffa89e8337519a8bfe58861e" => :sierra
    sha256 "42710f8cf1bef7628e61251e10bd0bf2a36f219e950fd40fb9d93561f87f4335" => :el_capitan
    sha256 "6d8a04d5bab5db00b80f5d6a35c639040ca0494e81ee85e7ae21bb52d8e617b8" => :yosemite
    sha256 "dc2eb72ebe79a0963dc9cae50ec6a38633740866b356e7521f37bf1c586a37f0" => :mavericks
  end

  option "with-doc", "Install man pages"

  depends_on "asciidoc" => :build if build.with? "doc"
  depends_on "openssl"
  depends_on "pinentry" => :optional

  def install
    system "make", "PREFIX=#{prefix}", "install"
    system "make", "MANDIR=#{man}", "install-doc" if build.with? "doc"
  end

  test do
    system "#{bin}/lpass", "--version"
  end
end
