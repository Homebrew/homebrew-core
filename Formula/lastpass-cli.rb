class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/archive/v1.3.1.tar.gz"
  sha256 "25dc9a0c99a10ee70b5b3991d525448c25f312cc69fa0216d7ac70c4ae384b1b"
  head "https://github.com/lastpass/lastpass-cli.git"

  bottle do
    cellar :any
    sha256 "8307f9a9616147fdac48ee9b0b60e8bd1fad3836d1664bd046badc2281d1af39" => :high_sierra
    sha256 "437a386cc38276851bc30137c1bfd1dbd11a21859dbad071d2f6253878e50bc6" => :sierra
    sha256 "94b4ee3c3bdd30c356926b5b3102c87a8ac2abc6d93206ed897cf6d4cb2ca2aa" => :el_capitan
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

    bash_completion.install "contrib/lpass_bash_completion"
    fish_completion.install "contrib/completions-lpass.fish"
  end

  test do
    system "#{bin}/lpass", "--version"
  end
end
