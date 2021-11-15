class Libpgm < Formula
  desc "Implements the PGM reliable multicast protocol"
  homepage "https://code.google.com/archive/p/openpgm/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/openpgm/libpgm-5.2.122~dfsg.tar.gz"
  version "5.2.122"
  sha256 "e296f714d7057e3cdb87f4e29b1aecb3b201b9fcb60aa19ed4eec29524f08bd8"

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

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    directory "openpgm/pgm"
  end

  def install
    cd "openpgm/pgm" do
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make", "install"
    end
  end
end
