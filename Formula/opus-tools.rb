class OpusTools < Formula
  desc "Utilities to encode, inspect, and decode .opus files"
  homepage "https://www.opus-codec.org"
  url "https://archive.mozilla.org/pub/opus/opus-tools-0.2.tar.gz"
  sha256 "b4e56cb00d3e509acfba9a9b627ffd8273b876b4e2408642259f6da28fa0ff86"
  license "BSD-2-Clause"

  bottle do
    cellar :any
    rebuild 1
    sha256 "964b3493cffeb5e32411c7a34e1813e8e83e940419aca39f50be7db9b0c8fab2" => :catalina
    sha256 "c4059aca471c3b1ec384323c1c801b844a2d2b61f17434ebc43c0accffde9f9b" => :mojave
    sha256 "0f8828cf6044f2d7b0cac9c591295b420244e8f086dc0afae9ae5420e6be7cb9" => :high_sierra
  end

  head do
    url "https://gitlab.xiph.org/xiph/opus-tools.git"

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
