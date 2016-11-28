class Libmongoc < Formula
  desc "Cross Platform MongoDB Client Library for C"
  homepage "http://mongoc.org/"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.5.0/mongo-c-driver-1.5.0.tar.gz"
  sha256 "b9b7514052fe7ec40786d8fc22247890c97d2b322aa38c851bba986654164bd6"

  bottle do
    cellar :any
    sha256 "60e78d583fe390907031da524e2beb62f9603726140ed283cabcc24502c3670d" => :sierra
    sha256 "07265fa17ae5d05d40290bab7df6f1d2545a36808cfdb6a76b5d5fff257b88c1" => :el_capitan
    sha256 "720675b55e6d98db395337582757fae96ebaa0c5e317c4f58cfc93ee8c3a4410" => :yosemite
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-man-pages",
                          "--enable-ssl=darwin"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <bson.h>
      int main() {
        bson_t *b;
        if (!bson_init_from_json(b, "{}", -1, NULL))
          return 1;
        bson_destroy(b);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lbson-1.0", "-I#{include}/libbson-1.0", "-o", "test"
    system "./test"
  end
end
