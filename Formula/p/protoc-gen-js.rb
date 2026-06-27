class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https://github.com/protocolbuffers/protobuf-javascript"
  url "https://github.com/protocolbuffers/protobuf-javascript/archive/refs/tags/v4.0.2.tar.gz"
  sha256 "a08244115ed0535971ec894abf078da90ad2c0938700612f90dc550f218627ee"
  license "BSD-3-Clause"
  revision 4
  head "https://github.com/protocolbuffers/protobuf-javascript.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a4b7b234db355df7123d5a5108ad7ce1437c611f7ce9a9ab6d5e017512e1febf"
    sha256 cellar: :any, arm64_sequoia: "a14d45463a161dda8b3fc8c15e61b51261087f1b356171c11391ab4b7a94720b"
    sha256 cellar: :any, arm64_sonoma:  "8437358f5a7f29ea135cddc132dcadbfbf3ae21f4314b0a582b3906c014ae7d1"
    sha256 cellar: :any, sonoma:        "33e37a6fa3d29466bba5c7556132ef6cdad2e97662a40265d6fc8f3e567e1551"
    sha256 cellar: :any, arm64_linux:   "30ad4c116ae931f587c3c44bc9b7a050584a6f263a2be4d46ada5a1ade7ee131"
    sha256 cellar: :any, x86_64_linux:  "cd5a8f364cb15b559457e3e2cd709d24482e2bafe72e28664554c751fa225cb7"
  end

  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "protobuf"

  # We manually build rather than use Bazel as Bazel will build its own copy of Abseil
  # and Protobuf that get statically linked into binary. Check for any upstream changes at
  # https://github.com/protocolbuffers/protobuf-javascript/blob/main/generator/BUILD.bazel
  def install
    system ENV.cxx, "-std=c++17", "generator/generate-version-header.cc", "-o", "generate-version-header"
    system "./generate-version-header", "package.json", "generator/version.h"
    protobuf_flags = Utils.safe_popen_read("pkgconf", "--cflags", "--libs", "protobuf").chomp.split.uniq
    system ENV.cxx, "-std=c++17", "generator/js_generator.cc", "generator/protoc-gen-js.cc",
                    "generator/well_known_types_embed.cc", "-o", "protoc-gen-js", "-I.", *protobuf_flags, "-lprotoc"
    bin.install "protoc-gen-js"
  end

  test do
    (testpath/"person.proto").write <<~PROTO
      syntax = "proto3";

      message Person {
        int64 id = 1;
        string name = 2;
      }
    PROTO
    system Formula["protobuf"].bin/"protoc", "--js_out=import_style=commonjs:.", "person.proto"
    assert_path_exists testpath/"person_pb.js"
    refute_predicate (testpath/"person_pb.js").size, :zero?
  end
end
