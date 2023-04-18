class Msgpack < Formula
  desc "Library for a binary-based efficient data interchange format"
  homepage "https://msgpack.org/"
  url "https://github.com/msgpack/msgpack-c/releases/download/c-6.0.0/msgpack-c-6.0.0.tar.gz"
  sha256 "3654f5e2c652dc52e0a993e270bb57d5702b262703f03771c152bba51602aeba"
  license "BSL-1.0"
  head "https://github.com/msgpack/msgpack-c.git", branch: "c_master"

  livecheck do
    url :stable
    regex(/^c[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e41b85a88da3012d8a7819799333410558cca1ef59663fda84718be0856002e6"
    sha256 cellar: :any,                 arm64_monterey: "1d14abff9537f4d85dee74c10ce6f73fafa8e8719c5be05bfda9a836cbe732ad"
    sha256 cellar: :any,                 arm64_big_sur:  "f3842a4dd94cf91e0259f5cf95e325314c664fe5b68b0a15d1a45739096b62e9"
    sha256 cellar: :any,                 ventura:        "7abad795d8f0b89d7927db89147ba2a5273e04cdfdcda30d9bc402fef4352ce6"
    sha256 cellar: :any,                 monterey:       "7b02d0690b3ca73cacf020eb6de303370b7d6def89b9769f0bd18222722e4903"
    sha256 cellar: :any,                 big_sur:        "e422e0f9f84e2fa558e75e5145abcba59ef61c72dacdf757eb185694a58c08a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3dfeade8b72c260d4745892f254ceb72535502293f6ddd04d04f19cb7affa35"
  end

  depends_on "cmake" => :build

  def install
    # C++ Headers are now in msgpack-cxx
    system "cmake", "-S", ".", "-B", "build", "-DMSGPACK_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # `libmsgpackc` was renamed to `libmsgpack-c`, but this needlessly breaks dependents.
    # TODO: Remove this when upstream bumps the `SOVERSION`, since this will require dependent rebuilds.
    lib.glob(shared_library("libmsgpack-c", "*")).each do |dylib|
      dylib = dylib.basename
      old_name = dylib.to_s.sub("msgpack-c", "msgpackc")
      lib.install_symlink dylib => old_name
    end
  end

  test do
    refute_empty lib.glob(shared_library("libmsgpackc", "2")),
                 "Upstream has bumped `SOVERSION`! The workaround in the `install` method can be removed"

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

    system ENV.cc, "-o", "test", "test.c", "-L#{lib}", "-lmsgpack-c"
    assert_equal "1\n2\n3\n", `./test`
  end
end
