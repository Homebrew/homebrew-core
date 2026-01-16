class Bsdsfv < Formula
  desc "SFV utility tools"
  homepage "https://bsdsfv.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/bsdsfv/bsdsfv/1.18/bsdsfv-1.18.tar.gz"
  sha256 "577245da123d1ea95266c1628e66a6cf87b8046e1a902ddd408671baecf88495"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "1f9574e283a380ebdba76ba7ede0ad884261ee528e481f77cd4783e3d5b890e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "524701069b0a0b5434b2cead350b18ef4bb2b394d7a82cc73c3fab9baed107ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e645fb99bfc780d0de8de68c504d7d10eba8337d3dc4108409171211a902239e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81531b6407c9081e4118d7abd4ed94f9f84899e349b6785141874bd0fd375390"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30b9057ddfd9c6135bec8299b07b4070df1b9d27c78cbfdf02b60af48628915d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f2a24ab528de05007b43da3e52628380f4bf6acf8d0d9d2d52cd3defd0c429c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6330adc3385cc94183d0719c5b5868a4db2aa055551469eccccd29fae2b0c568"
    sha256 cellar: :any_skip_relocation, ventura:        "6f7366afb6194e3d5feca85e754ab5e0b3a2d02c5c56419aa2d9d7372a85afee"
    sha256 cellar: :any_skip_relocation, monterey:       "5e790ea081550e93842400272cd2e50ef34abf7d24bd04d258bfb9f4554a3ca4"
    sha256 cellar: :any_skip_relocation, big_sur:        "3fe4cd9e74eb5d55bf3ecc10a675600ade3b4f0d56b94d2bcfd9d71e91cae302"
    sha256 cellar: :any_skip_relocation, catalina:       "3abfd33001c44edc6b03905559f8565f923001aa1ccc3a3247ebd073d226ccaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "19ee5c984fc2bfc91735e2e53532b59f8acd4e8831bab55c215844b99f17beee"
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
