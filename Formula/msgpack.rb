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
    sha256 cellar: :any,                 arm64_ventura:  "7e65889bade2f78f3373705054899204cee0231846d4bebe6eae1d39e05b3b60"
    sha256 cellar: :any,                 arm64_monterey: "fa335fc10a2e2f18dbcee140395b16a993a748962b6587f2ad876369a9594608"
    sha256 cellar: :any,                 arm64_big_sur:  "66990bdf0c267d1d690402de218ee96673151185c9a13966f034ef99944524dd"
    sha256 cellar: :any,                 ventura:        "86ac3464c6d3916e87608abd01ae38a41ad482bffded92c5ecc0dc439ae93c72"
    sha256 cellar: :any,                 monterey:       "0539ae4c5aca3dc551fdf8b84687da544e3167ce64d5402147a4ac5a6c0fe807"
    sha256 cellar: :any,                 big_sur:        "614bb9b2d4a9af0fa98d88866356ebf6a59b8b82cf92353b323a548e3b8d781d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa3ec3a41319a0480e6842e0fb766aad89fa81b4a5b48fd9179ace88582c8320"
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
