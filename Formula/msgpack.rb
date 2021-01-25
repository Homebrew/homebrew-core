class Msgpack < Formula
  desc "Library for a binary-based efficient data interchange format"
  homepage "https://msgpack.org/"
  url "https://github.com/msgpack/msgpack-c/releases/download/cpp-3.3.0/msgpack-3.3.0.tar.gz"
  sha256 "6e114d12a5ddb8cb11f669f83f32246e484a8addd0ce93f274996f1941c1f07b"
  license "BSL-1.0"
  head "https://github.com/msgpack/msgpack-c.git"

  bottle do
    sha256 "434fdf5aea4bdee584755531889cbbe40a093a4a85dbb993dcca60516a6aaeab" => :big_sur
    sha256 "c66ea6e1ec61f9fa18e8146c9aa8306e39adcb0b31d2d6c6784ddd3d17a479f7" => :arm64_big_sur
    sha256 "bb3e3af7ce4994911518db90db9ff4747e72492832b3aa98ff7c82fd3d5990b2" => :catalina
    sha256 "f418d11d056dd08160b27088d19ee12d4a9e36dbd913ffae8d2c9838a1449475" => :mojave
    sha256 "7424d6d9dee3edd0f07c4ea6f11567255dea4f1bbffbb6c41f20c5412952028d" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # Reference: https://github.com/msgpack/msgpack-c/blob/HEAD/QUICKSTART-C.md
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
