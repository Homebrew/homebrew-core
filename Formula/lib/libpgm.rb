class Libpgm < Formula
  desc "Implements the PGM reliable multicast protocol"
  homepage "https://github.com/steve-o/openpgm"
  license "LGPL-2.1-or-later"
  head "https://github.com/steve-o/openpgm.git", branch: "master"

  stable do
    url "https://github.com/steve-o/openpgm/archive/refs/tags/release-5-3-128.tar.gz"
    version "5.3.128"
    sha256 "8d707ef8dda45f4a7bc91016d7f2fed6a418637185d76c7ab30b306499c6d393"

    # Fix build on ARM. Remove in the next release along with stable block
    patch do
      url "https://github.com/steve-o/openpgm/commit/8d507fc0af472762f95da44036fb77662ff4cd2a.patch?full_index=1"
      sha256 "070c3b52fd29f6c594bb6728a960bc19e4ea7d00b2c7eac51e33433e07d775b3"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "d78bfc9ac9873ac2b3756155e86e9df6fca639872048aed76446856e08635588"
    sha256 cellar: :any,                 arm64_sequoia:  "0f2266ecabc1128e3a70ff8e31864e6cd556bd20b66cc2c74fd32011b2646dc4"
    sha256 cellar: :any,                 arm64_sonoma:   "6764decaa99670740309808e8be1ac3d75dbb9b8b8f8037d10c6dbe2932e0290"
    sha256 cellar: :any,                 arm64_ventura:  "27bb9366ecfabb4dafc81a54a1b7c39259cfcad13337a63c18a55ea0de26f2d5"
    sha256 cellar: :any,                 arm64_monterey: "8461b86788d5f5d6b6240ca78169bc120dd05fc753dcf052403537f5bd173382"
    sha256 cellar: :any,                 arm64_big_sur:  "350aa74e762a89d01bd49237b95bb92bb97b213da951f72d5d8febe372c636da"
    sha256 cellar: :any,                 sonoma:         "a439be588514dae60781db58923be9b42dbd6e29c7ce2acfe44e81f13e291f8c"
    sha256 cellar: :any,                 ventura:        "4b1dc1f1e98ea4d6bbf9c47f069baec6521a9b35753044cdc2d5f1066ddd82f4"
    sha256 cellar: :any,                 monterey:       "6c5d4b6c58e5afb6c32f4b8681b5065dbc6c8920b505d14dd1dc49479411e56a"
    sha256 cellar: :any,                 big_sur:        "f5679fa01ad2590b57001a261b8eeffef2daf437021d75564fea4603ce348f68"
    sha256 cellar: :any,                 catalina:       "1b9796c9a1047eb51760a3e727258469338ddaa156bf592e83c65040ac17824c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9def3024f67a4c2b91300eaeb65829f0ffa47652c47118354f96b1f82fdfe149"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5ceaf537037fb5918336027ab1ec0ab5484ca2230a58d6ba2b72569a416e9ed"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "python" => :build

  def install
    workdir = build.stable? ? "openpgm/pgm" : "pgm"
    cd workdir do
      # Fix version number
      cp "openpgm-5.2.pc.in", "openpgm-5.3.pc.in" if build.stable?
      system "./bootstrap.sh"
      system "./configure", *std_configure_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~C
      #include <pgm/pgm.h>

      int main(void) {
        pgm_error_t* pgm_err = NULL;
        if (!pgm_init (&pgm_err)) {
          return 1;
        }
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}/pgm-5.3", "-L#{lib}", "-lpgm", "-o", "test"
    system "./test"
  end
end
