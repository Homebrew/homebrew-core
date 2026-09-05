class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https://github.com/protocolbuffers/protobuf-javascript"
  url "https://github.com/protocolbuffers/protobuf-javascript/archive/refs/tags/v4.0.2.tar.gz"
  sha256 "a08244115ed0535971ec894abf078da90ad2c0938700612f90dc550f218627ee"
  license "BSD-3-Clause"
  revision 8
  head "https://github.com/protocolbuffers/protobuf-javascript.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d858dcc6d0121a490648c277b14acf1fe1b658e2f2820e1b24cd8dfe78b3d447"
    sha256 cellar: :any, arm64_sequoia: "0768d75104e59ed14922b896d345c4e65d47d500ee32887c99ec0ad02142531f"
    sha256 cellar: :any, arm64_sonoma:  "860f315446577c6d2f48c6e89e9d3d3527797a5c6d130ad97613133f86e3d6bd"
    sha256 cellar: :any, arm64_linux:   "2dc5fa816e3b65263eaf213279bb11581ecf0cb6a9c2feba45aefc3f38896425"
    sha256 cellar: :any, x86_64_linux:  "a7247e684fda2f23d63f3212f23498002802c84ee67cd18a8d1c873571893140"
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
