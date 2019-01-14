class OpusTools < Formula
  desc "Utilities to encode, inspect, and decode .opus files"
  homepage "https://www.opus-codec.org"
  url "https://archive.mozilla.org/pub/opus/opus-tools-0.2.tar.gz"
  sha256 "b4e56cb00d3e509acfba9a9b627ffd8273b876b4e2408642259f6da28fa0ff86"

  bottle do
    cellar :any
    sha256 "68b6c2204f54060c61d47394b2bfdb3a318a124ce0a0e8ad2ab494ae4d9feee8" => :mojave
    sha256 "30e9b3686b445c3344ba2e1ba59a813a1251a93381a367ae0cb09236fc5f7ca4" => :high_sierra
    sha256 "4e2f1a811051ee31ec55dc10016f2c91dc097ec38a91916274ead42b5146d0c9" => :sierra
  end

  head do
    url "https://git.xiph.org/opus-tools.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "libogg"
  depends_on "libopusenc"
  depends_on "opus"
  depends_on "opusfile"

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
