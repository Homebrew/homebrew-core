class Msgpack < Formula
  desc "Library for a binary-based efficient data interchange format"
  homepage "https://msgpack.org/"
  url "https://github.com/msgpack/msgpack-c/releases/download/cpp-3.2.0/msgpack-3.2.0.tar.gz"
  sha256 "fbaa28c363a316fd7523f31d1745cf03eab0d1e1ea5a1c60aa0dffd4ce551afe"
  head "https://github.com/msgpack/msgpack-c.git"

  bottle do
    sha256 "39e10722612be82489faf28fd4d31cbe230d52600ef46ddfc8691b7635b78e89" => :catalina
    sha256 "ab771d78cc52a6cf537744a44277fdf669132fe14efa05c7772454657e0bf37d" => :mojave
    sha256 "a1e6e41dcc5e31bd3c68f1049f6a5bc9d39d2d602b913378b7c921a030e17e17" => :high_sierra
    sha256 "4381f2208ce63ef84869ce6f4f46e61cbc6cee9d39254af9006746d987e97759" => :sierra
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
