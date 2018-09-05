class Mimic < Formula
  desc "Lightweight text-to-speech engine based on CMU Flite"
  homepage "https://mimic.mycroft.ai"
  url "https://github.com/MycroftAI/mimic/archive/1.2.0.2.tar.gz"
  sha256 "6adcc9911b09d6e9513add41ad9dfc0893ece277f556419869520a0f0708c102"
  revision 4

  bottle do
    cellar :any
    sha256 "b88a35a402c068c4efa17d9ca35a502292ff3d0ee162dfbe4fe3b48e192d76cb" => :mojave
    sha256 "20fc7273db85a315903304d758aa74edf0f7bfc5947a9ee261661fc2b38e699f" => :high_sierra
    sha256 "8072f200df17d949891fce6fec60489527a3ae4e9f4f3a59cae6b42f86e19b0c" => :sierra
    sha256 "e91d1999945a78d5f88d20c47702585630e61d010ba52742bec6af159d1ca47c" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "icu4c"
  depends_on "portaudio"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-shared",
                          "--enable-static",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"mimic", "-t", "Hello, Homebrew!", "test.wav"
    assert_predicate testpath/"test.wav", :exist?
  end
end
