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
    sha256 cellar: :any,                 arm64_monterey: "0352df73a00db8db517c8a5e48ed15f9a90ea51fc526269a5e7363a45615ce5f"
    sha256 cellar: :any,                 arm64_big_sur:  "d7eae0a2f8294b8515e2c68ad16a898998828d8d63fe2a434fd304af49cc7fb9"
    sha256 cellar: :any,                 monterey:       "cf75a7581708d1b0f22e94fbfe3082598fe7cb34b5f43fd7e415fae6bf6cf1c7"
    sha256 cellar: :any,                 big_sur:        "3b2917e9ee9d7accc72f8366773406c7721b6085b6993bb92a696b8ac38ff866"
    sha256 cellar: :any,                 catalina:       "3065405373d29d0542eccad99df604559572e03fa6af5c95599704f98365cf34"
    sha256 cellar: :any,                 mojave:         "adce4966a82c538788b73fc22b56d8ed9d876a7610746aac35c37cf430381088"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52f1929b0e22ddc0526c64af5306dc2ebfcb0c8d02ce565f9576fdea96c2b2e1"
  end

  depends_on "libgpg-error"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

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
