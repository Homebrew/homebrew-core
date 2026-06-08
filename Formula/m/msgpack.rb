class Msgpack < Formula
  desc "Library for a binary-based efficient data interchange format"
  homepage "https://msgpack.org/"
  url "https://github.com/msgpack/msgpack-c/releases/download/c-7.0.0/msgpack-c-7.0.0.tar.gz"
  sha256 "0f1b34a42ea20b35350ad774e56666f64e860ce22d787626f2b3d2ab67061639"
  license "BSL-1.0"
  head "https://github.com/msgpack/msgpack-c.git", branch: "c_master"

  livecheck do
    url :stable
    regex(/^c[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5b0be627f681dd9b08da1608e4708003180a8f8610c94b7ab7734a1b192dcb27"
    sha256 cellar: :any, arm64_sequoia: "efe585511f515eeffd8dbb903f343c7eb8149c10f9998766b7bc02b0870b2be7"
    sha256 cellar: :any, arm64_sonoma:  "f9b682e64bfd163ebac34b8b49b6e2113a23bc29c1b906120e49031edb14082b"
    sha256 cellar: :any, sonoma:        "3a9905fc993e223505b40c4648e5cbce4fdfb3e47f0a35bc0c63aa89efa28d77"
    sha256 cellar: :any, arm64_linux:   "2909eff3eba27a3c1cb8f6a2c4c023ee30bcf0cdf3706082e93463242b6b7d75"
    sha256 cellar: :any, x86_64_linux:  "76e87896a3bdede1a668b14cb5bd6365d792308ed7f58ebd984611f9f2ba2b46"
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
