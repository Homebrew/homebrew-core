class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https://github.com/protocolbuffers/protobuf-javascript"
  url "https://github.com/protocolbuffers/protobuf-javascript/archive/refs/tags/v4.0.2.tar.gz"
  sha256 "a08244115ed0535971ec894abf078da90ad2c0938700612f90dc550f218627ee"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/protocolbuffers/protobuf-javascript.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6dce10245392ff7711a7185fb3f60268ca070b10454dbdc7baf4048419a2ed24"
    sha256 cellar: :any,                 arm64_sequoia: "e1bbb31e68120de1f8435a0587a5fe5556541fed9062af2e3406d3413dacb05b"
    sha256 cellar: :any,                 arm64_sonoma:  "a4834b9e4d402fa94452b4ee0147970d7cbe5e5b1374c8c69c21b6d9ddc32c32"
    sha256 cellar: :any,                 sonoma:        "309e24f10e65ec16832486bf9c481a7440abe82ba96bf77dc5912d93ff1dfde3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e889ae582b8e8112ad0cadd17e778f0e30f0b472a511fa2a43720fa5087bfa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "805141f5d4261a07f5ab32b8a8b04c323663ece3119a21f7c0d3f8b8bf8b52f4"
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
