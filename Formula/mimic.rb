class Mimic < Formula
  desc "Lightweight text-to-speech engine based on CMU Flite"
  homepage "https://mimic.mycroft.ai"
  url "https://github.com/MycroftAI/mimic/archive/1.2.0.2.tar.gz"
  sha256 "6adcc9911b09d6e9513add41ad9dfc0893ece277f556419869520a0f0708c102"
  revision 5

  bottle do
    cellar :any
    sha256 "a4cef5d7b056865ff6d0b8c5a009a8d2e1037fd456819544081f9cd79ba8a8a3" => :mojave
    sha256 "8405d021a89307dceade05dbae580dfbc0a8ba804259e6d9a3aa02ca27e9962e" => :high_sierra
    sha256 "09ed32fa5a02c7f3bd7137041712660b3cad1cf7bb9552eb83a02164953f8bac" => :sierra
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
