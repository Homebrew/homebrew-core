class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https://github.com/protocolbuffers/protobuf-javascript"
  url "https://github.com/protocolbuffers/protobuf-javascript/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "123fac2e86109b24e80ccd356aa914e268bf5863ad1354d224d6ceaed6f5c45b"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/protocolbuffers/protobuf-javascript.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ca12ea6599efeedd3cf511a173e37da21b84df144d9735e2507255470d593bed"
    sha256 cellar: :any,                 arm64_sequoia: "205d481940df0d700e1d9c4c3d558a0e99292c2dab5a3326c3f52d1b11f42946"
    sha256 cellar: :any,                 arm64_sonoma:  "2bf6a22e1ec1b538178affd2df7b0076e7d9a3e4a26c8187640446a8822b92c6"
    sha256 cellar: :any,                 sonoma:        "3eada4b863ae7e2981a9665904cb60d4253c81448f3897c52e5bb07c04b72a8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9fe1dc5f351a6ea94d9b632e1349255fed5ab8f388bb7509a9dac29c54f55b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ab4081275b0bafb529632cb95698ecdddf7f912b4a57135d561c6e6f421dd04"
  end

  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "protobuf"

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
    system Formula["protobuf"].bin/"protoc", "--js_out=import_style=commonjs:.", "person.proto"
    assert_path_exists testpath/"person_pb.js"
    refute_predicate (testpath/"person_pb.js").size, :zero?
  end
end
