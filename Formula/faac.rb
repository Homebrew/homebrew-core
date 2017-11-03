class Faac < Formula
  desc "ISO AAC audio encoder"
  homepage "http://www.audiocoding.com/faac.html"
  url "https://downloads.sourceforge.net/project/faac/faac-src/faac-1.29/faac-1.29.9.tar.gz"
  sha256 "238cb4453b6fe4eebaffb326e40a63786a155e349955c4259925006fa1e2839e"

  bottle do
    cellar :any
    sha256 "7cee7bed3b2cd0971f8c4e7310e5b5419cdfd1c647325616a8320e8727f9c634" => :high_sierra
    sha256 "95f62317820b7349c89dd7a4252797e206ebadc48d4d94ea77961c4510018e39" => :sierra
    sha256 "bf47a2f8598623b87948657e8e740d243e89ce6410b992368b9bf5dfee51784d" => :el_capitan
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
