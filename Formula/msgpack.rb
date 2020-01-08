class Msgpack < Formula
  desc "Library for a binary-based efficient data interchange format"
  homepage "https://msgpack.org/"
  url "https://github.com/msgpack/msgpack-c/releases/download/cpp-3.2.1/msgpack-3.2.1.tar.gz"
  sha256 "433cbcd741e1813db9ae4b2e192b83ac7b1d2dd7968a3e11470eacc6f4ab58d2"
  head "https://github.com/msgpack/msgpack-c.git"

  bottle do
    sha256 "096ec799c036e133005a99e95fc2c16d69ba5c12e6d42cb22aa4cd13d45b53c7" => :catalina
    sha256 "3b801b0f1ff7467f3d9c5613b43f8caf326a399a18f039a85075edb599abd704" => :mojave
    sha256 "37747bceccf59ae6041667c52765c424fba6363aef6326c032d35b3b59bf3d14" => :high_sierra
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
