class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https://github.com/protocolbuffers/protobuf-javascript"
  url "https://github.com/protocolbuffers/protobuf-javascript/archive/refs/tags/v4.0.2.tar.gz"
  sha256 "a08244115ed0535971ec894abf078da90ad2c0938700612f90dc550f218627ee"
  license "BSD-3-Clause"
  revision 6
  head "https://github.com/protocolbuffers/protobuf-javascript.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d350b722f34456b084badee334f98e6e388a07b9ded3f0c3adea336252a2df83"
    sha256 cellar: :any, arm64_sequoia: "c0fb428ff2b7fd6d41edfc9da2d85cbaeef88ce7a11c3f1f33041f57368da74f"
    sha256 cellar: :any, arm64_sonoma:  "9d3a3b220211b974a49b4be5dd49c854584b64a81177e32457d494456427e8bc"
    sha256 cellar: :any, sonoma:        "08e7ca31cc16d1b8472ff30c194b25e16c61647b7aed2319ed78711fca5b1aed"
    sha256 cellar: :any, arm64_linux:   "6454139df7277f17aa50acf55581a1592ab38e852627b3a48db35d61dffb0424"
    sha256 cellar: :any, x86_64_linux:  "0cb810ab23472d924e0e810c12ac6bd62d602f89a630b5a97264e07e026e34c9"
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
