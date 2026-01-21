class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https://github.com/protocolbuffers/protobuf-javascript"
  url "https://github.com/protocolbuffers/protobuf-javascript/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "123fac2e86109b24e80ccd356aa914e268bf5863ad1354d224d6ceaed6f5c45b"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/protocolbuffers/protobuf-javascript.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d2ec3f4def7537a0b7914930359c6be29fe8540c78813c9897f10f52794df587"
    sha256 cellar: :any,                 arm64_sequoia: "5ba804ed8a353281249a393a64267a6e72f6bc549d59b81f1510b48bcc6bc0f4"
    sha256 cellar: :any,                 arm64_sonoma:  "77ce1a096a808eef9f954067a31899ade43f1a640469182a99a8e5c907c4e77f"
    sha256 cellar: :any,                 sonoma:        "ab22cb0f23d2cf77a1a72f3121e51621df025a53a9684164a06d108dafded777"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da7bbee442bef8c90d5234a2999bea748a9836c3ba907831623146d1235a2068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b62043eda4656354f1e1982fe0313ff73c6f1da1ab6b52d1e296ab0469661801"
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
