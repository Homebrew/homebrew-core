class Bsdsfv < Formula
  desc "SFV utility tools"
  homepage "https://bsdsfv.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bsdsfv/bsdsfv/1.18/bsdsfv-1.18.tar.gz"
  sha256 "577245da123d1ea95266c1628e66a6cf87b8046e1a902ddd408671baecf88495"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30b9057ddfd9c6135bec8299b07b4070df1b9d27c78cbfdf02b60af48628915d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f2a24ab528de05007b43da3e52628380f4bf6acf8d0d9d2d52cd3defd0c429c"
    sha256 cellar: :any_skip_relocation, monterey:       "5e790ea081550e93842400272cd2e50ef34abf7d24bd04d258bfb9f4554a3ca4"
    sha256 cellar: :any_skip_relocation, big_sur:        "3fe4cd9e74eb5d55bf3ecc10a675600ade3b4f0d56b94d2bcfd9d71e91cae302"
    sha256 cellar: :any_skip_relocation, catalina:       "3abfd33001c44edc6b03905559f8565f923001aa1ccc3a3247ebd073d226ccaa"
    sha256 cellar: :any_skip_relocation, mojave:         "e500396c1a26993727df9ccc8d878e0a4fbc353326206dffcbd18b9fc8071247"
    sha256 cellar: :any_skip_relocation, high_sierra:    "28bee35fbc8c0be9e1182287c58340898d29d9ba0f910109974af6efcb5cd61f"
    sha256 cellar: :any_skip_relocation, sierra:         "38b9d278b430e250b384c5ba2baf3e74dfe0771c5ceea45686022ecb01616ee2"
    sha256 cellar: :any_skip_relocation, el_capitan:     "404ec03e044a019a487adfab90012a29a6655fe67b907d9b4e9a46d4f6c57a9b"
    sha256 cellar: :any_skip_relocation, yosemite:       "fd15cb46a9499bcd1182e8fe4a6ae1de9fb77ced85186601ef6c6579a22d9c51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffa21308fb20dc93bbe80e8735590e035e0810e858a088f50c8d1ce1cfee041d"
  end

  # bug report:
  # https://sourceforge.net/p/bsdsfv/bugs/1/
  # Patch from MacPorts
  patch :DATA

  def install
    bin.mkpath

    inreplace "Makefile" do |s|
      s.change_make_var! "INSTALL_PREFIX", prefix
      s.change_make_var! "INDENT", "indent"
      s.gsub! "	${INSTALL_PROGRAM} bsdsfv ${INSTALL_PREFIX}/bin", "	${INSTALL_PROGRAM} bsdsfv #{bin}/"
    end

    system "make", "all"
    system "make", "install"
  end
end

__END__
--- a/bsdsfv.c	2012-09-25 07:31:03.000000000 -0500
+++ b/bsdsfv.c	2012-09-25 07:31:08.000000000 -0500
@@ -44,5 +44,5 @@
 typedef struct sfvtable {
	char filename[FNAMELEN];
-	int crc;
+	unsigned int crc;
	int found;
 } SFVTABLE;
