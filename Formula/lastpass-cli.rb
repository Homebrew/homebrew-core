class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/archive/v1.1.0.tar.gz"
  sha256 "6616dc7ee321d078fafd650359cd0ab8a90abd41d10a54527c99b682d218f0be"
  head "https://github.com/lastpass/lastpass-cli.git"

  bottle do
    cellar :any
    sha256 "de66d98752658b1fd0833dc5299de068286f94404380dda4c58b6f3d6e0f477c" => :sierra
    sha256 "efd0e2844d5e17f66306db0738b2b9e73fa0608032f980fa91cd445221b6a183" => :el_capitan
    sha256 "4b29dc6cee13e3df0674a3e60914141cb30ac9ac7c9a1a2376638e96e724a2b4" => :yosemite
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
