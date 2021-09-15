class Libksba < Formula
  desc "X.509 and CMS library"
  homepage "https://www.gnupg.org/related_software/libksba/"
  url "https://gnupg.org/ftp/gcrypt/libksba/libksba-1.6.0.tar.bz2"
  sha256 "dad683e6f2d915d880aa4bed5cea9a115690b8935b78a1bbe01669189307a48b"
  license any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"]

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libksba/"
    regex(/href=.*?libksba[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "d7eae0a2f8294b8515e2c68ad16a898998828d8d63fe2a434fd304af49cc7fb9"
    sha256 cellar: :any,                 big_sur:       "3b2917e9ee9d7accc72f8366773406c7721b6085b6993bb92a696b8ac38ff866"
    sha256 cellar: :any,                 catalina:      "3065405373d29d0542eccad99df604559572e03fa6af5c95599704f98365cf34"
    sha256 cellar: :any,                 mojave:        "adce4966a82c538788b73fc22b56d8ed9d876a7610746aac35c37cf430381088"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52f1929b0e22ddc0526c64af5306dc2ebfcb0c8d02ce565f9576fdea96c2b2e1"
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
