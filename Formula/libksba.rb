class Libksba < Formula
  desc "X.509 and CMS library"
  homepage "https://www.gnupg.org/related_software/libksba/"
  url "https://gnupg.org/ftp/gcrypt/libksba/libksba-1.3.5.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libksba/libksba-1.3.5.tar.bz2"
  sha256 "41444fd7a6ff73a79ad9728f985e71c9ba8cd3e5e53358e70d5f066d35c1a340"

  bottle do
    cellar :any
    sha256 "b7b47004aa87a4464b74992bca866d0fe7960597085f99463598d37264ed2a01" => :sierra
    sha256 "65fbc5b34f507b1bac6d7a3dc926eab3aeb90e028f1e4dad5868039d61dfdf76" => :el_capitan
    sha256 "113e407c5d04392cedbcf901841508d68a9ce8ad858cbff2edf9b2a56eef787a" => :yosemite
    sha256 "a3c9609e2dad2939138cb109ed75903b633f84f3e914ecba1b83de91aa2eccd2" => :mavericks
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"ksba-config", prefix, opt_prefix
  end

  test do
    system "#{bin}/ksba-config", "--libs"
  end
end
