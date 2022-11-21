class Msgpuck < Formula
  desc "Simple and efficient MsgPack binary serialization library"
  homepage "https://rtsisyk.github.io/msgpuck/"
  url "https://github.com/rtsisyk/msgpuck/archive/2.0.tar.gz"
  sha256 "01e6aa55d4d52a5b19f7ce9a9845506d9ab3f5abcf844a75e880b8378150a63d"
  license "BSD-2-Clause"
  head "https://github.com/rtsisyk/msgpuck.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26e05760c2486aec44bc8d1f4fb968bcb9fecb980c693a8134e034d6d7885877"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ca7fca2ee5beb10e49b21dd3f810450442147158a291e023acc8e7982630c7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d52c18b8fef8cbd5b59f41e014a2c85610787084714a4086c26152cd6cc59a6b"
    sha256 cellar: :any_skip_relocation, ventura:        "7ab7c36f070e933b3ced38035beb6b9ea68981d62e1278ad622632cb259a7721"
    sha256 cellar: :any_skip_relocation, monterey:       "350569d8ace92f17a35a90345712219f94596e8857ed222e1ca86ab086fa06ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0137f8e139ada6b1c98315f7e9982a44131b133a48aa7959d64015880d7f430"
    sha256 cellar: :any_skip_relocation, catalina:       "01dbdca0333694d379bd7b209d52d8dd8e48f5416d9df441d43cdb29c2751738"
    sha256 cellar: :any_skip_relocation, mojave:         "0fedf815d4ba46d10e5fe7910cbcc06f1ea2906e40a4ef994ffd3aa04289c423"
    sha256 cellar: :any_skip_relocation, high_sierra:    "50197e08a5b55fbe804109ad01dfa815a6dde2b11b688d89a58154fed2d8d54f"
    sha256 cellar: :any_skip_relocation, sierra:         "6f4011d177bf2e42f94f853bc93283ada6c48df8fdb7269135def453e65e598d"
    sha256 cellar: :any_skip_relocation, el_capitan:     "b0accfedd2582109acec3297878bb943360282520a31b0d1c16c4ec1aa70a362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24b63f0499e6e5bc5b138228966945ff497936a4679da98a44aa18cfeec538a1"
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
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmsgpuck", "-o", "test"
    system "#{testpath}/test"
  end
end
