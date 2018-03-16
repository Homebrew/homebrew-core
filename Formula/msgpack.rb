class Msgpack < Formula
  desc "Library for a binary-based efficient data interchange format"
  homepage "https://msgpack.org/"
  url "https://github.com/msgpack/msgpack-c/releases/download/cpp-2.1.5/msgpack-2.1.5.tar.gz"
  sha256 "6126375af9b204611b9d9f154929f4f747e4599e6ae8443b337915dcf2899d2b"
  head "https://github.com/msgpack/msgpack-c.git"

  bottle do
    sha256 "85933b57f67eaa2f08bdd634bf4615603586775d7c4558d2309f3894bf53a51c" => :high_sierra
    sha256 "4666095a79d52aafd4f430d107621ce7478bd6a1fc605aa565c5c0fab25f82e3" => :sierra
    sha256 "bd0d61248dbbf8fc6859d22a3ccc3b4a62289f6f5745c4415f129431614ae173" => :el_capitan
    sha256 "f29ea6e3fa33c5ad7b3a6172ad1e993e7ebfd30bc745769da4f093f3283031a3" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # Reference: https://github.com/msgpack/msgpack-c/blob/master/QUICKSTART-C.md
    (testpath/"test.c").write <<~EOS
      #include <msgpack.h>
      #include <stdio.h>

      int main(void)
      {
         msgpack_sbuffer* buffer = msgpack_sbuffer_new();
         msgpack_packer* pk = msgpack_packer_new(buffer, msgpack_sbuffer_write);
         msgpack_pack_int(pk, 1);
         msgpack_pack_int(pk, 2);
         msgpack_pack_int(pk, 3);

         /* deserializes these objects using msgpack_unpacker. */
         msgpack_unpacker pac;
         msgpack_unpacker_init(&pac, MSGPACK_UNPACKER_INIT_BUFFER_SIZE);

         /* feeds the buffer. */
         msgpack_unpacker_reserve_buffer(&pac, buffer->size);
         memcpy(msgpack_unpacker_buffer(&pac), buffer->data, buffer->size);
         msgpack_unpacker_buffer_consumed(&pac, buffer->size);

         /* now starts streaming deserialization. */
         msgpack_unpacked result;
         msgpack_unpacked_init(&result);

         while(msgpack_unpacker_next(&pac, &result)) {
             msgpack_object_print(stdout, result.data);
             puts("");
         }
      }
    EOS

    system ENV.cc, "-o", "test", "test.c", "-L#{lib}", "-lmsgpackc"
    assert_equal "1\n2\n3\n", `./test`
  end
end
