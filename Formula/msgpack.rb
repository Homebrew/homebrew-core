class Msgpack < Formula
  desc "Library for a binary-based efficient data interchange format"
  homepage "https://msgpack.org/"
  url "https://github.com/msgpack/msgpack-c/releases/download/c-4.0.0/msgpack-c-4.0.0.tar.gz"
  sha256 "420fe35e7572f2a168d17e660ef981a589c9cbe77faa25eb34a520e1fcc032c8"
  license "BSL-1.0"
  head "https://github.com/msgpack/msgpack-c.git", branch: "c_master"

  livecheck do
    url :stable
    regex(/^c[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e3df397ffc4f82b7e321fd9a31f16979af074db08f663f485b474c0119643c7e"
    sha256 cellar: :any,                 arm64_big_sur:  "94519c5e879506abb6e665f65982df1b461e53e83904a4ff88bd9ef34a05db83"
    sha256 cellar: :any,                 monterey:       "c457413b910943f87cffc03951d9dbe5cc60c23abf862c572dab0b18011bb682"
    sha256 cellar: :any,                 big_sur:        "a6922853180da9206a75c706502c24971bfa73abf6aeed7b8341a6824e179580"
    sha256 cellar: :any,                 catalina:       "702f8b5c56c9f4111a68111d4e03466894ac98c43a9e3127ddfb74559bad201d"
    sha256 cellar: :any,                 mojave:         "ae673e0c74680acca0996eba8d4a2d7d6048c1986706f85f12f64a3d53750db8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "542fb3791b98792a25705dd2de670e9d0ac492f4d03246614052a81ed4bc02d4"
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
