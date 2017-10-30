class Faac < Formula
  desc "ISO AAC audio encoder"
  homepage "http://www.audiocoding.com/faac.html"
  url "https://downloads.sourceforge.net/project/faac/faac-src/faac-1.29/faac-1.29.8.3.tar.gz"
  sha256 "3d85267b394dd8ebd5dd88845b25bc5e5e4fc88ac5affb8a2807f50368dc3b41"

  bottle do
    cellar :any
    sha256 "1184a2c62467c59f783412bf24824c6ce10ca920bee361caaea19a810f232471" => :high_sierra
    sha256 "e6cbb94356716e9bbc11daf55c25f1e55c27b1015c01cc463ffad664f732e08c" => :sierra
    sha256 "c74ebbc64a420957f2a78ec19a1f64f0dc69e15169b2063a85963c4ff4563135" => :el_capitan
  end

  def install
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
