class Msgpack < Formula
  desc "Library for a binary-based efficient data interchange format"
  homepage "https://msgpack.org/"
  url "https://github.com/msgpack/msgpack-c/releases/download/c-6.0.1/msgpack-c-6.0.1.tar.gz"
  sha256 "a349cd9af28add2334c7009e331335af4a5b97d8558b2e9804d05f3b33d97925"
  license "BSL-1.0"
  head "https://github.com/msgpack/msgpack-c.git", branch: "c_master"

  livecheck do
    url :stable
    regex(/^c[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b7e5117cdadb73ce58b278a96b99d11fe2380280b8a0f79c06cf89a6c82f6a25"
    sha256 cellar: :any,                 arm64_ventura:  "9666b5d9ac86ec85fdfc9195aa1064bf8604d9c283a44c217a74762f4bc0cd0c"
    sha256 cellar: :any,                 arm64_monterey: "92fdc6ce888b36f23e1a8768e562c03caeb523bda509a9ba8794548fc6d54f39"
    sha256 cellar: :any,                 sonoma:         "6281f5d270814c2bfc4a68430f546737160cd10434819b0c117774c51b46a509"
    sha256 cellar: :any,                 ventura:        "844bf1facb3017cd8e1f19801c3d1f4750e72887f0b2de175b75bda6eb45c8a0"
    sha256 cellar: :any,                 monterey:       "3d8dee34a712fd1f29731060d65f0a927c91370f4b24759a935144aadc5a2b6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcd2a3799c88a200f8326838ef2ff2014a951b5e493a23a403426c43b59e6754"
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
