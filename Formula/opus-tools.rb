class OpusTools < Formula
  desc "Utilities to encode, inspect, and decode .opus files"
  homepage "https://www.opus-codec.org"
  url "https://archive.mozilla.org/pub/opus/opus-tools-0.1.10.tar.gz"
  sha256 "a2357532d19471b70666e0e0ec17d514246d8b3cb2eb168f68bb0f6fd372b28c"

  bottle do
    cellar :any
    sha256 "62d9154105f9d7be511899c04959bb76c669ee573cb4597b1a34291de613ad57" => :sierra
    sha256 "32b77b8739b8e44eac8b3b45791291c3a1efbaf2b1c99b1f74b32d2beae5c795" => :el_capitan
    sha256 "97a0d5affca76c00fec6d56ca3b6b2984e68f518380edd9098b6c49b0f465c46" => :yosemite
  end

  head do
    url "https://git.xiph.org/opus-tools.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "opus"
  depends_on "flac"
  depends_on "libogg"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    cp test_fixtures("test.wav"), "test.wav"
    assert_match "Encoding complete", shell_output("#{bin}/opusenc test.wav enc.opus 2>&1")
    assert_predicate testpath/"enc.opus", :exist?, "Failed to encode to enc.opus"
    assert_match "Decoding complete", shell_output("#{bin}/opusdec enc.opus dec.wav 2>&1")
    assert_predicate testpath/"dec.wav", :exist?, "Failed to decode to dec.wav"
  end
end
