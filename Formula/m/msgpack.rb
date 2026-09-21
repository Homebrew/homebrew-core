class Msgpack < Formula
  desc "Library for a binary-based efficient data interchange format"
  homepage "https://msgpack.org/"
  url "https://github.com/msgpack/msgpack-c/releases/download/c-7.0.2/msgpack-c-7.0.2.tar.gz"
  sha256 "6ae50f69612871aa01de76bec904165cd2a2fc30ff9f653f2f60a663c5c1a86c"
  license "BSL-1.0"
  head "https://github.com/msgpack/msgpack-c.git", branch: "c_master"

  livecheck do
    url :stable
    regex(/^c[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "29aed8bdee290649c3f15afa65d03d506f1993b1a7745f499b4bb88706340c35"
    sha256 cellar: :any, arm64_tahoe:       "0256ac35fddc2e310727c2ebe9303775de6bfa54e71dde35a2c99f3c5e03f651"
    sha256 cellar: :any, arm64_sequoia:     "e096ebf62c431777d00dde83182ee02212b2f0053d5dbb7abbff5800832771b9"
    sha256 cellar: :any, arm64_sonoma:      "a556ce7e3d22d2d64815e9aedb508b89b4a7f674f14bc1b33f41dc1d4bc828aa"
    sha256 cellar: :any, sonoma:            "e558e2f6d522fb6a298a375e4a93333344342370b69e31d87ca478445d80acc3"
    sha256 cellar: :any, arm64_linux:       "a584537e1d1b3e013c83a88a34eb4dfe68aea696617538c349c9c0bb1885930a"
    sha256 cellar: :any, x86_64_linux:      "d40b5a46ed029404c3d7c820c5b0126d3f776966f8edd8defda0d1405dafa698"
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
    (testpath/"test.c").write <<~C
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
    C

    system ENV.cc, "-o", "test", "test.c", "-L#{lib}", "-lmsgpack-c"
    assert_equal "1\n2\n3\n", `./test`
  end
end
