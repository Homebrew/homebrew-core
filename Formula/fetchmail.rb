class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.16.tar.xz"
  sha256 "044b9a0ac03afbae7744979defe3e2e32e39141bca68fd0c8deda2ed40884fb9"

  livecheck do
    url :stable
    regex(%r{url=.*?/branch_\d+(?:\.\d+)*?/fetchmail[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6d4f805965f9aaf3b0516e8d357a24e7b0a1efb412c5323f1c52b3846f65fbc1"
    sha256 cellar: :any, big_sur:       "82b93256195c412594d12da24e09afd240b98eb29974b33928ec6340f35a957c"
    sha256 cellar: :any, catalina:      "beddf283c52526596dab5e787361ad372cde4021ecf9810a91f284c5df98c248"
    sha256 cellar: :any, mojave:        "03ab76529b8a534c2e391b7a96debd9b16b883d559860b9f225f7c6a69e07860"
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/fetchmail", "--version"
  end
end
