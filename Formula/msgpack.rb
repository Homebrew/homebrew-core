class Msgpack < Formula
  desc "Library for a binary-based efficient data interchange format"
  homepage "https://msgpack.org/"
  url "https://github.com/msgpack/msgpack-c/releases/download/c-4.0.0/msgpack-c-4.0.0.tar.gz"
  sha256 "420fe35e7572f2a168d17e660ef981a589c9cbe77faa25eb34a520e1fcc032c8"
  license "BSL-1.0"
  head "https://github.com/msgpack/msgpack-c.git", branch: "c_master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "8b16bfe485fb0bdacd68a14b8a6acb8811e61c50f9178c6dccc63e6e6f32fea3"
    sha256 cellar: :any,                 big_sur:       "2c29077e763920ec59779a5f1be1a0206fda9f8f8c82447356ff616eb572d7fe"
    sha256 cellar: :any,                 catalina:      "3cc886ce8752df92a979fb8c3559738fe105379954eb2c2b660abb8769f4e64b"
    sha256 cellar: :any,                 mojave:        "5e597990ddb6b7044af3deeb1e08a5a1dcce697c14e671d725ad0b041d670099"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e584e20f25a9142d3cea90accdaf4253c7d4b1fbe72e10337fc480af7b7d21e"
  end

  depends_on "cmake" => :build

  def install
    # C++ Headers are now in msgpack-cxx
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # Reference: https://github.com/msgpack/msgpack-c/blob/c_master/QUICKSTART-C.md
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
