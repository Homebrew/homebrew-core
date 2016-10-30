class Msgpack < Formula
  desc "Library for a binary-based efficient data interchange format"
  homepage "https://msgpack.org/"
  url "https://github.com/msgpack/msgpack-c/releases/download/cpp-2.0.0/msgpack-2.0.0.tar.gz"
  sha256 "41de0989a3385061ab7307a1005655e780def6fc9c89af0ec942616aa787e136"
  head "https://github.com/msgpack/msgpack-c.git"

  bottle do
    sha256 "ea7602eaad716977168403c6c250e4121d4c28f78c6d96f2d80769976b981bfe" => :sierra
    sha256 "21fefa9786fae112931ea32d84d05e5f2dde5f06883df1cd9c7d1a365290e206" => :el_capitan
    sha256 "59dc7ecd1e3ee33c3bdf221098b3011cb1dfd8c8eb329e25105c1ce3f8e89b46" => :yosemite
    sha256 "68f9cadf64e4a3100a034f0b750c9b4ca9cb461b6b0dec84004e984f71ab0126" => :mavericks
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
