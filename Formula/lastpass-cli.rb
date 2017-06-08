class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/archive/v1.2.0.tar.gz"
  sha256 "17bd9413933ac34d86793c38578298c122835a85132b827fb2fc782b24034aef"
  head "https://github.com/lastpass/lastpass-cli.git"

  bottle do
    cellar :any
    sha256 "6632f4ddb5d99984f76bc7f50d4adf99002efbc0a5cc89c06224805af2b05b11" => :sierra
    sha256 "8921710f235709e42360ccb48d66636d24917e8084e79f0c828dc9796c4503b2" => :el_capitan
    sha256 "2f0184ca15f14a9aa1444a9748e1ecbca75f71383af272eb86da587dff0c8a9d" => :yosemite
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
