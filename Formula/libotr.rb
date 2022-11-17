class Libotr < Formula
  desc "Off-The-Record (OTR) messaging library"
  homepage "https://otr.cypherpunks.ca/"
  url "https://otr.cypherpunks.ca/libotr-4.1.1.tar.gz"
  sha256 "8b3b182424251067a952fb4e6c7b95a21e644fbb27fbd5f8af2b2ed87ca419f5"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?libotr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "758ad5aecffe69404a6b32062bbdef4a7c6b89dab5d635b1f1f41b46f676e12f"
    sha256 cellar: :any,                 arm64_monterey: "fe41c2686379f8b67aafc307e703775ab8060fb074734561e67cdc958a912e45"
    sha256 cellar: :any,                 arm64_big_sur:  "f6a94af91827558244757f9fe7d856251f0b7b2de78e1ee38f6059808f1f51e7"
    sha256 cellar: :any,                 ventura:        "3a1e5f35391e9b9ab7048a440b74f412100a541d43d6dd52bb6db73f3758a216"
    sha256 cellar: :any,                 monterey:       "afa5f29cdb8a4a6618ecea8a75129679c6ade432cdae03f1e31caadeec8ddadd"
    sha256 cellar: :any,                 big_sur:        "f59b69aa5af8b636f8bea1511fa63fed116f9c9571864fb7b44c21655e8a099b"
    sha256 cellar: :any,                 catalina:       "8ecf904a816fc69adc5e8fe904ca2ef1b1d147090d2f6ee694ad6b5c07faa02c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a88f909cde9e876f1f3a9ffe30d2ba483715ba3fc03c188f78bc07758a18491"
  end

  depends_on "libgcrypt"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  # Fix client.c:624:30: error: 'PF_UNIX' undeclared (first use in this function)
  patch do
    url "https://sources.debian.org/data/main/libo/libotr/4.1.1-5/debian/patches/0006-include-socket.h.patch"
    sha256 "cfda75f8c5bba2e735d2b4f1bb90f60b45fa1d554a97fff75cac467f7873ebde"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
