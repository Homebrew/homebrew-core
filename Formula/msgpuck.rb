class Msgpuck < Formula
  desc "A simple and efficient MsgPack binary serialization library"
  homepage "https://rtsisyk.github.io/msgpuck/"
  url "https://github.com/rtsisyk/msgpuck/archive/2.0.tar.gz"
  sha256 "01e6aa55d4d52a5b19f7ce9a9845506d9ab3f5abcf844a75e880b8378150a63d"
  head "https://github.com/rtsisyk/msgpuck.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "01dbdca0333694d379bd7b209d52d8dd8e48f5416d9df441d43cdb29c2751738" => :catalina
    sha256 "0fedf815d4ba46d10e5fe7910cbcc06f1ea2906e40a4ef994ffd3aa04289c423" => :mojave
    sha256 "50197e08a5b55fbe804109ad01dfa815a6dde2b11b688d89a58154fed2d8d54f" => :high_sierra
    sha256 "6f4011d177bf2e42f94f853bc93283ada6c48df8fdb7269135def453e65e598d" => :sierra
    sha256 "b0accfedd2582109acec3297878bb943360282520a31b0d1c16c4ec1aa70a362" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~'EOS'
      /* Encode and decode an array */
      #include <assert.h>
      #include <msgpuck.h>

      int main() {
        const char *str = "hello world";

        char buf[1024];
        char *w = buf;
        const char *pos = buf;

        w = mp_encode_array(w, 4);
        w = mp_encode_uint(w, 10);
        w = mp_encode_str(w, str, strlen(str));
        w = mp_encode_bool(w, true);
        w = mp_encode_double(w, 3.1415);

        assert(mp_typeof(*pos) == MP_ARRAY );
        mp_decode_array(&pos);
        assert(mp_typeof(*pos) == MP_UINT  );
        mp_next(&pos);
        assert(mp_typeof(*pos) == MP_STR   );
        mp_next(&pos);
        assert(mp_typeof(*pos) == MP_BOOL  );
        mp_next(&pos);
        assert(mp_typeof(*pos) == MP_DOUBLE);
        mp_next(&pos);

        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lmsgpuck", "-o", "test", "test.c"
    system "#{testpath}/test"
  end
end
