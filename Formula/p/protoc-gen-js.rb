class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https://github.com/protocolbuffers/protobuf-javascript"
  url "https://github.com/protocolbuffers/protobuf-javascript/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "123fac2e86109b24e80ccd356aa914e268bf5863ad1354d224d6ceaed6f5c45b"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-javascript.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a27b258bb10edab9b63fc5369ad1aa69c08dff92f0254ee362c3e13cfb56bab9"
    sha256 cellar: :any,                 arm64_sequoia: "f9aaf39aaf4e44b46042ebc30d78323506989bd99bc6506c7724f3d27278a8d7"
    sha256 cellar: :any,                 arm64_sonoma:  "28a81b5dddab5a76b27d6edb431e3233b045941c606ccc7602d458d2bd16ae8d"
    sha256 cellar: :any,                 sonoma:        "b06d02871820eb5ab4d1abbacedee1b87315659c99e1a896435cd15dbee2e361"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8a1357bed9994ef94eccbb2cc514698945c9412da2250bd561b4e0b4e609226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6823a5537a307f4327de399bbfdd70e2868434f7deef20e7765ab5b7b403487"
  end

  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "protobuf@29"

  # We manually build rather than use Bazel as Bazel will build its own copy of Abseil
  # and Protobuf that get statically linked into binary. Check for any upstream changes at
  # https://github.com/protocolbuffers/protobuf-javascript/blob/main/generator/BUILD.bazel
  def install
    system "node", "generate-version-header.js", "generator/version.h"
    protobuf_flags = Utils.safe_popen_read("pkgconf", "--cflags", "--libs", "protobuf").chomp.split.uniq
    system ENV.cxx, "-std=c++17", *Dir["generator/*.cc"], "-o", "protoc-gen-js", "-I.", *protobuf_flags, "-lprotoc"
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
    system Formula["protobuf@29"].bin/"protoc", "--js_out=import_style=commonjs:.", "person.proto"
    assert_path_exists testpath/"person_pb.js"
    refute_predicate (testpath/"person_pb.js").size, :zero?
  end
end
