class Jansson < Formula
  desc "C library for encoding, decoding, and manipulating JSON"
  homepage "https://digip.org/jansson/"
  url "https://github.com/akheron/jansson/releases/download/v2.15.0/jansson-2.15.0.tar.gz"
  sha256 "070a629590723228dc3b744ae90e965a569efb9c535b3309b52e80e75d8eb3be"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1a1aa9d485c3bdc370ad50fc00667a284e343974db3fb5f492398d04759fb808"
    sha256 cellar: :any,                 arm64_sequoia: "d50fc42e5f0fd4e7a2bb892c30d7af77acbbdc0b78ea98560d5c8517d3122ad5"
    sha256 cellar: :any,                 arm64_sonoma:  "452a4f19fc5fa2a299cb6abcf0dde93f4b3b198b82c90046ade5c98d5b541993"
    sha256 cellar: :any,                 sonoma:        "400c04c24f2676ea8bdc6293ea5625c4c3375f9f4e5f6fc8a263c54d3667bea3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f93d9bf83d35a0aed6bdfd062fc18dc1c02ccdfe139ab5cb5cb592e13e41d7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91b24e62741d5b67d096f8c2592d68a8589533b851b80fe7da9c3b3e5d3bfa5b"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-L#{lib}", "-ljansson", "-o", "test"
    system "./test"
  end
end
