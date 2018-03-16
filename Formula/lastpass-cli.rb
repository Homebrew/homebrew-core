class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/archive/v1.3.0.tar.gz"
  sha256 "bbcfd673d668287e773eef44da65fbd2f292daa213a39528f31037c528dbcfe4"
  head "https://github.com/lastpass/lastpass-cli.git"

  bottle do
    cellar :any
    sha256 "2b0d96c9f06a721e3d30b881a4ac33fc85f68c7d8e31c59fd41a8c4d4a05a934" => :high_sierra
    sha256 "c4efb6b73af37fdcf55694432d47bc0ae6e5548f57e217129b9a4ccfed6dc5c6" => :sierra
    sha256 "6f0967d8bdba9c7f48b514be1497c3a2a3defa77d5ea11be2dd1b4fdb1888616" => :el_capitan
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
