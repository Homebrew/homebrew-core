class Libmobi < Formula
  desc "C library for handling Kindle (MOBI) formats of ebook documents"
  homepage "https://github.com/bfabiszewski/libmobi/"
  url "https://github.com/bfabiszewski/libmobi/releases/download/v0.7/libmobi-0.7.tar.gz"
  sha256 "188535dd86f028ba607aae916040ff8e69672dc972eb1e62f0a354d43908e834"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "43d37ed55ec4c3c5c376456d0caf9d28092e2781d0dbd4301fa58a456402311a"
    sha256 cellar: :any, big_sur:       "321971da1ec7a654f2c2d1422502b6accae3f392e1cfd6af50b633d6a058d554"
    sha256 cellar: :any, catalina:      "88ac957feb1b298437656e370c79ec851b8e8c4144e2de616f180669452f7423"
    sha256 cellar: :any, mojave:        "4fcf8e0c1355976f7f1bd44d2395e3e67c167b3dca04a9d6a8194c38ea6aa9f8"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <mobi.h>
      int main() {
        MOBIData *m = mobi_init();
        if (m == NULL) {
          return 1;
        }
        mobi_free(m);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lmobi", "-o", "test"
    system "./test"
  end
end
