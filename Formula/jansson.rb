class Jansson < Formula
  desc "C library for encoding, decoding, and manipulating JSON"
  homepage "http://www.digip.org/jansson/"
  url "http://www.digip.org/jansson/releases/jansson-2.10.tar.gz"
  sha256 "78215ad1e277b42681404c1d66870097a50eb084be9d771b1d15576575cf6447"

  bottle do
    cellar :any
    sha256 "f71130560290bd3567370e16bd6da01c62b742262ba838785697148273b572a2" => :sierra
    sha256 "709661eacbb18126715fae9ba5f2b48d6e7d9e7660f601fce67b601f0d5333a8" => :el_capitan
    sha256 "03a6016b16023b314916147e7ece853c39450a249644fceb2dac3a0417b11fdc" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <jansson.h>
      #include <assert.h>

      int main()
      {
        json_t *json;
        json_error_t error;
        json = json_loads("\\"foo\\"", JSON_DECODE_ANY, &error);
        assert(json && json_is_string(json));
        json_decref(json);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-ljansson", "-o", "test"
    system "./test"
  end
end
