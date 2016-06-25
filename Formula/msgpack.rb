class Msgpack < Formula
  desc "Library for a binary-based efficient data interchange format"
  homepage "https://msgpack.org/"
  url "https://github.com/msgpack/msgpack-c/releases/download/cpp-2.0.0/msgpack-2.0.0.tar.gz"
  sha256 "41de0989a3385061ab7307a1005655e780def6fc9c89af0ec942616aa787e136"
  head "https://github.com/msgpack/msgpack-c.git"

  bottle do
    cellar :any
    sha256 "d7fbe4332a60de9474d4dbfb14ded1438da70e710b7feb6694da5446e5a6707f" => :el_capitan
    sha256 "fdcdb01e8b75847f10b695a76cca99c76b78757811d1b9fc08e4e1bde43baa18" => :yosemite
    sha256 "080c493d334f376fca8f1caceb2d34324152531f7612972cb982ee79b498c8c0" => :mavericks
  end

  depends_on "cmake" => :build

  fails_with :llvm do
    build 2334
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # Reference: http://wiki.msgpack.org/display/MSGPACK/QuickStart+for+C+Language
    (testpath/"test.c").write <<-EOS.undent
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

    system ENV.cc, "-o", "test", "test.c", "-lmsgpackc"
    assert_equal "1\n2\n3\n", `./test`
  end
end
