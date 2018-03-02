class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/archive/v1.2.2.tar.gz"
  sha256 "26c93ae610932139dacaff2e0f916c5628def48bb4129b4099101cf4e6c7c499"
  head "https://github.com/lastpass/lastpass-cli.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ec24db20d729545039bc5966086486eedb0491736a6d6cb1f4b534ce7e537aeb" => :high_sierra
    sha256 "13c003b786d04d64780e05d925d0b9438b81b295480cbb29079927ad4453d600" => :sierra
    sha256 "6417a0b427f60634240fa5c06a2c33cb06187b76b1ff4c0f611a370f0fb6dd12" => :el_capitan
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
