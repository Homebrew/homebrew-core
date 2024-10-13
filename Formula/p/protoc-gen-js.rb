class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https://github.com/protocolbuffers/protobuf-javascript"
  url "https://github.com/protocolbuffers/protobuf-javascript/archive/refs/tags/v3.21.4.tar.gz"
  sha256 "8cef92b4c803429af0c11c4090a76b6a931f82d21e0830760a17f9c6cb358150"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/protocolbuffers/protobuf-javascript.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "77c2c092386684372d8a228e5a1b107b008898117104feef491b6283bd1dd25c"
    sha256 cellar: :any,                 arm64_sonoma:  "7544980adc91f9214cd364b48e180afa3a51573bdaff74f434a0b145989d0d6f"
    sha256 cellar: :any,                 arm64_ventura: "2f2c45a57da4ec466bd629fe83163e46deaba79e9534ac60957594ce675dd979"
    sha256 cellar: :any,                 sonoma:        "255f728321c7def862a5162bd92c41ca96bb0168e852d102a3a79288a7c73ca8"
    sha256 cellar: :any,                 ventura:       "447d1c305f96d8c8780b8a692031a71bb1380336d521f41ed70d0a9ef1ff32c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4db9d43324d19e7286a18a995f09a7f05edd90d53537839bee5b1c602568c2f3"
  end

  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "protobuf"

  # We manually build rather than use Bazel as Bazel will build its own copy of Abseil
  # and Protobuf that get statically linked into binary. Check for any upstream changes at
  # https://github.com/protocolbuffers/protobuf-javascript/blob/main/generator/BUILD.bazel
  def install
    protobuf_flags = Utils.safe_popen_read("pkg-config", "--cflags", "--libs", "protobuf").chomp.split.uniq
    system ENV.cxx, "-std=c++17", *Dir["generator/*.cc"], "-o", "protoc-gen-js", "-I.", *protobuf_flags, "-lprotoc"
    bin.install "protoc-gen-js"
  end

  test do
    (testpath/"person.proto").write <<~EOS
      syntax = "proto3";

      message Person {
        int64 id = 1;
        string name = 2;
      }
    EOS
    system Formula["protobuf"].bin/"protoc", "--js_out=import_style=commonjs:.", "person.proto"
    assert_predicate testpath/"person_pb.js", :exist?
    refute_predicate (testpath/"person_pb.js").size, :zero?
  end
end
