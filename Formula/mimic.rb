class Mimic < Formula
  desc "Lightweight text-to-speech engine based on CMU Flite"
  homepage "https://mimic.mycroft.ai"
  url "https://github.com/MycroftAI/mimic/archive/1.2.0.2.tar.gz"
  sha256 "6adcc9911b09d6e9513add41ad9dfc0893ece277f556419869520a0f0708c102"
  revision 1

  bottle do
    cellar :any
    sha256 "df5c5b4e95e7e0f99b77167e8ec09f50e62021b3195dfb0c8b84a8f8aecb1ce9" => :high_sierra
    sha256 "cb00a072b0730aa23c82d8f3b6208f5e20fdec69e557d2fe669ecbacc98dc3c3" => :sierra
    sha256 "129d1b1e63b7d5ee583fb955286272297b4f159e74c746e319ffaf94aead0951" => :el_capitan
    sha256 "ae14c6662d7241dc75258eac52090b09bd0a69f7bfc6465f47b040930f184afd" => :yosemite
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
