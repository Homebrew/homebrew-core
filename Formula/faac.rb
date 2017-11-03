class Faac < Formula
  desc "ISO AAC audio encoder"
  homepage "http://www.audiocoding.com/faac.html"
  url "https://downloads.sourceforge.net/project/faac/faac-src/faac-1.29/faac-1.29.9.tar.gz"
  sha256 "238cb4453b6fe4eebaffb326e40a63786a155e349955c4259925006fa1e2839e"

  bottle do
    cellar :any
    sha256 "1184a2c62467c59f783412bf24824c6ce10ca920bee361caaea19a810f232471" => :high_sierra
    sha256 "e6cbb94356716e9bbc11daf55c25f1e55c27b1015c01cc463ffad664f732e08c" => :sierra
    sha256 "c74ebbc64a420957f2a78ec19a1f64f0dc69e15169b2063a85963c4ff4563135" => :el_capitan
  end

  def install
    # Fix "error: initializer element is not a compile-time constant"
    # Reported 2 Nov 2017 https://sourceforge.net/p/faac/bugs/228/
    inreplace "libfaac/stereo.c", "sqrt(2)", "M_SQRT2"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"faac", test_fixtures("test.mp3"), "-P", "-o", "test.m4a"
    assert_predicate testpath/"test.m4a", :exist?
  end
end
