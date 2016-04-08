class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/archive/v0.9.0.tar.gz"
  sha256 "e7314f0dfeec86add7c19c053ee34bb7a176e462e71727d2b345481d2d136800"
  head "https://github.com/lastpass/lastpass-cli.git"

  bottle do
    cellar :any
    sha256 "abf5e87bfdf5953746476f5ac1bc7b44cd51ea94af1f32f07bd0f3c93b89d4ce" => :el_capitan
    sha256 "e8ca9db904d637852830910ff8905c4be206a7b15ebbf04c0e1ead5073ea9642" => :yosemite
    sha256 "bf2a47f74b67df21875b3a01e87acad4d5e3d69ccff79987d73ca56e8020134a" => :mavericks
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
