class Msgpack < Formula
  desc "Library for a binary-based efficient data interchange format"
  homepage "https://msgpack.org/"
  url "https://github.com/msgpack/msgpack-c/releases/download/c-6.1.0/msgpack-c-6.1.0.tar.gz"
  sha256 "674119f1a85b5f2ecc4c7d5c2859edf50c0b05e0c10aa0df85eefa2c8c14b796"
  license "BSL-1.0"
  head "https://github.com/msgpack/msgpack-c.git", branch: "c_master"

  livecheck do
    url :stable
    regex(/^c[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "5a412a93e8367e656022e5c0810632cba0d5c924e1cdf5f5bc64f1a0501a6aa9"
    sha256 cellar: :any,                 arm64_sequoia:  "fef7b080476f8c2ea5d3478775fb8ba7861cb2c5b25a5c06a575eabf303d6085"
    sha256 cellar: :any,                 arm64_sonoma:   "7a4291f35809d557ff65bdec687fc12468b557d8c27499fad634b84fc27c6a65"
    sha256 cellar: :any,                 arm64_ventura:  "9798f9eb15c335c663271387feedb42a24953c8a869d657e1b3d58868fb97177"
    sha256 cellar: :any,                 arm64_monterey: "eb59d97db589ebe5afa0c0ae7f8ac4f07ae39433c323e6d90532301ff19a6c69"
    sha256 cellar: :any,                 sonoma:         "f8a10c653f0e071f725866c790eebef4161f4c172315388aefdada07682c46bd"
    sha256 cellar: :any,                 ventura:        "c7e8c2eddc2b55a71e6e6a6a3f63c90cb66369727b990cc553470b7b91ceb599"
    sha256 cellar: :any,                 monterey:       "0c0c337dad512678ec60426c448aded9965daef3b4ee89eec9f98faad1789012"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "07097acd7e8f4e885cf3917b684a45721344db7aa38edea9ad01c8c6acdbe141"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95d7d9a41f1c13c5ce0e1a2ec77f119a3b55e2ad88f0f98d3e5a04d323896171"
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
