class Msgpack < Formula
  desc "Library for a binary-based efficient data interchange format"
  homepage "https://msgpack.org/"
  url "https://github.com/msgpack/msgpack-c/releases/download/cpp-3.1.1/msgpack-3.1.1.tar.gz"
  sha256 "8592d12e19ac3796889b8358bc8f78df9272e6aa7a9ea1834bafd68e4073549a"
  head "https://github.com/msgpack/msgpack-c.git"

  bottle do
    sha256 "b708aac89fc31da2a6bed1c6341554215159ff36d0e08ce0f8e1eaf73aefeeb4" => :mojave
    sha256 "a0cfd5ae310c3e1abe7415d388faa423b503b3536bc57784de1777260de6c596" => :high_sierra
    sha256 "3f55efbc271b3945eec23cd7bcb00c8810f33b37c20052e58175d5702bcddaf0" => :sierra
    sha256 "12741b879defd02e2c4a0955ebe559addff483d30189504d4bdeb4572e99226a" => :el_capitan
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
