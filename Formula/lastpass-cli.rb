class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/archive/v1.2.2.tar.gz"
  sha256 "26c93ae610932139dacaff2e0f916c5628def48bb4129b4099101cf4e6c7c499"
  head "https://github.com/lastpass/lastpass-cli.git"

  bottle do
    cellar :any
    sha256 "99b21d0071c0485bb6ad14fc4f73c60cfcf9f3f15af433d990b35e098113cb4a" => :high_sierra
    sha256 "162e608bb8f6694bac3c4bd156005ba262a08252bbb7ac2f2d77c3c1357ef220" => :sierra
    sha256 "b1757bed02d604980af5ffda05b48659e88766b7d113f78f0e77509394cd1d98" => :el_capitan
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
