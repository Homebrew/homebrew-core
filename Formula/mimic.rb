class Mimic < Formula
  desc "Lightweight text-to-speech engine based on CMU Flite"
  homepage "https://mimic.mycroft.ai"
  url "https://github.com/MycroftAI/mimic/archive/1.2.0.2.tar.gz"
  sha256 "6adcc9911b09d6e9513add41ad9dfc0893ece277f556419869520a0f0708c102"
  revision 1

  bottle do
    cellar :any
    sha256 "09d3e611608f56c7a64e4a072b5a0de0513310bc99127c84db1c82250968511c" => :high_sierra
    sha256 "97afa7f2c1e7af748bdcc594cd381523dda0ebcba1571e4cef3c6f8325cd01cc" => :sierra
    sha256 "152fe1ffcd399e1fe78021df4d4213ddaa2c47c603471271796283c6c85005d4" => :el_capitan
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
