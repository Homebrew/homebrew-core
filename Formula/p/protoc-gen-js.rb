class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https://github.com/protocolbuffers/protobuf-javascript"
  url "https://github.com/protocolbuffers/protobuf-javascript/archive/refs/tags/v4.0.2.tar.gz"
  sha256 "a08244115ed0535971ec894abf078da90ad2c0938700612f90dc550f218627ee"
  license "BSD-3-Clause"
  revision 7
  head "https://github.com/protocolbuffers/protobuf-javascript.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1da7a35558a37932145702672dd796107822efeb965c16c1a461a80521ed9859"
    sha256 cellar: :any, arm64_sequoia: "4d145e4e24f88ae548ec6d1caf752d19cc4337b2c370b8317d9847056f79c1ea"
    sha256 cellar: :any, arm64_sonoma:  "37335bf998b55db5f3025bbceba4dd2b1d246376d2ee6b5a259fa3786f0c0d94"
    sha256 cellar: :any, sonoma:        "bb516123c525e45eb9762eadc0685d76267ec831eb69272670cf0775724646ed"
    sha256 cellar: :any, arm64_linux:   "142b38b8d5c0584e656df13179f1b74d485cd6519e434f5d2f4c426c5a29dd39"
    sha256 cellar: :any, x86_64_linux:  "98f055e9165c0445897a6fff879acc7fbd5369ffc961062c45aa4add400c7656"
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
