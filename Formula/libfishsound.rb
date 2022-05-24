class Libfishsound < Formula
  desc "Decode and encode audio data using the Xiph.org codecs"
  homepage "https://xiph.org/fishsound/"
  url "https://downloads.xiph.org/releases/libfishsound/libfishsound-1.0.0.tar.gz", using: :homebrew_curl
  mirror "https://ftp.osuosl.org/pub/xiph/releases/libfishsound/libfishsound-1.0.0.tar.gz"
  sha256 "2e0b57ce2fecc9375eef72938ed08ac8c8f6c5238e1cae24458f0b0e8dade7c7"
  license "BSD-3-Clause"

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/libfishsound/?C=M&O=D"
    regex(/href=.*?libfishsound[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "04042bd85b176dc50f99153f267fae3e5f82176ad010aaccff0c71d1434ab550"
    sha256 cellar: :any,                 arm64_big_sur:  "3ec17aed1c22c99831e01e1938bf9b240439f45c130422dd90e06ccd8a57cd74"
    sha256 cellar: :any,                 monterey:       "7c299a38462e967259b6e396193585bf37c2a0d5bbce0e4dbbff32b15e9ed102"
    sha256 cellar: :any,                 big_sur:        "a1ae8b29698509de3de412402ce463cf32a08573348526dc42020731fdaff314"
    sha256 cellar: :any,                 catalina:       "5599c6eaed21c2f66ebb8209ca8e436fd306214de6d9db6ccf21bd9c2710e1b7"
    sha256 cellar: :any,                 mojave:         "f232242d49e8c2ae954e282e879e4a4a86b80d3e46364d74247af92efd613d96"
    sha256 cellar: :any,                 high_sierra:    "726c79b6e3ce5d71e9cf1d6b556a6daed33b5e8bd7269e2219b1474549dac17d"
    sha256 cellar: :any,                 sierra:         "50187bc6adea9322f20e1706d66859c941d6d2e8d1d8bfab091f088b20061760"
    sha256 cellar: :any,                 el_capitan:     "9cf94c3c6963895940e8720aef21c29b001257c918fce6b65685c33f8430f0e4"
    sha256 cellar: :any,                 yosemite:       "4fcfc4270d73ac2b0e8d8a4d1fe6b94a1093502b802ed327febb5286ad5140b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5db56944c47f7f4084a4645ef252841be006ad54ee48fb55530eda206e6732c3"
  end

  depends_on "pkg-config" => :build
  depends_on "libvorbis"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end
end
