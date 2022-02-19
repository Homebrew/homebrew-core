class Libpgm < Formula
  desc "Implements the PGM reliable multicast protocol"
  homepage "https://github.com/steve-o/openpgm"
  license "LGPL-2.1-or-later"
  head "https://github.com/steve-o/openpgm.git", branch: "master"

  stable do
    url "https://github.com/steve-o/openpgm/archive/release-5-3-128.tar.gz"
    version "5.3.128"
    sha256 "8d707ef8dda45f4a7bc91016d7f2fed6a418637185d76c7ab30b306499c6d393"

    # Fix build on ARM. Remove in the next release along with stable block
    patch do
      url "https://github.com/steve-o/openpgm/commit/8d507fc0af472762f95da44036fb77662ff4cd2a.patch?full_index=1"
      sha256 "070c3b52fd29f6c594bb6728a960bc19e4ea7d00b2c7eac51e33433e07d775b3"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "c893cae7dc32335748fcd6a01c5ce39248c77318bf96bb2a75e0d27dce10c0a3"
    sha256 cellar: :any, arm64_big_sur:  "f07813fb154e0e47acad079791155d2e5a9d69e45da24628b5052bdb0e2a971a"
    sha256 cellar: :any, monterey:       "5c8f0f5025d537858407b21a62c9edec4fda56a11ea3f7136fb2aed9154a1d84"
    sha256 cellar: :any, big_sur:        "27381fca9259e51fafa0515c5b21a6642ebba34b6e55a0f78e5b9b39be7cd0ba"
    sha256 cellar: :any, catalina:       "416f7e3ff857e0c20f20c7c4774403059bbd540d003f0a0a546e122c603f7be6"
    sha256 cellar: :any, mojave:         "0adcd6a17bbd37e11d0858c9ec7174b51932f33eb19a727c931acf1d719ab292"
    sha256 cellar: :any, high_sierra:    "cccc90b754683842714480dc0a099abd303426ab2b47fd9fd8d0172717d9bc17"
    sha256 cellar: :any, sierra:         "e84427aa937687e77701f8b0834866c86e6d4916685c769c4900403307b624c5"
    sha256 cellar: :any, el_capitan:     "24765bd6efa0aa65a333e3d5bb5a48159875b81cae8ca99c479fbda4133f49b9"
    sha256 cellar: :any, yosemite:       "ae0d1d980f84677fcaa08b1d9f35f1c9d4858e4239598530b7485e9f248def73"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

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
    (testpath/"test.c").write <<~EOS
      #include <pgm/pgm.h>

      int main(void) {
        pgm_error_t* pgm_err = NULL;
        if (!pgm_init (&pgm_err)) {
          return 1;
        }
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/pgm-5.3", "-L#{lib}", "-lpgm", "-o", "test"
    system "./test"
  end
end
