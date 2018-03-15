class Mimic < Formula
  desc "Lightweight text-to-speech engine based on CMU Flite"
  homepage "https://mimic.mycroft.ai"
  url "https://github.com/MycroftAI/mimic/archive/1.2.0.2.tar.gz"
  sha256 "6adcc9911b09d6e9513add41ad9dfc0893ece277f556419869520a0f0708c102"
  revision 2

  bottle do
    cellar :any
    sha256 "5f3ce8f5ca539aa8661b22c8dfc768001ad3d3d83dd209c2b33e7f2ed86d4a82" => :high_sierra
    sha256 "2ce3923f3dfbd7a7e47d0d7f794291b1d32f74d990989b0643480178d2ad4304" => :sierra
    sha256 "8d4320a8cf2badd931d5e5750c4777acde53d653766b6485a104644ca1271b87" => :el_capitan
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
