class Mimic < Formula
  desc "Lightweight text-to-speech engine based on CMU Flite"
  homepage "https://mimic.mycroft.ai"
  url "https://github.com/MycroftAI/mimic/archive/1.2.0.2.tar.gz"
  sha256 "6adcc9911b09d6e9513add41ad9dfc0893ece277f556419869520a0f0708c102"
  revision 4

  bottle do
    cellar :any
    sha256 "26b8f664a926f40d85afae92e0c3a4f5035017373b7b3129ca9d2fe961a0169e" => :high_sierra
    sha256 "4b81c2894454ce34ff155244f88fdabf542519e13befdaa55e89bac0e126b707" => :sierra
    sha256 "da7eca33821161618bc078a46ea315c713cb087ec5ecc17c5f43ebd95e9d152e" => :el_capitan
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
