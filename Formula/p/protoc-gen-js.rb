class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https://github.com/protocolbuffers/protobuf-javascript"
  url "https://github.com/protocolbuffers/protobuf-javascript/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "7d3cd714bf99660ecc96882468a5a23465efca07064ff8105da634372649ee6e"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-javascript.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a87ff83edfcd03c7f32f6e56f28d439813f6a9e336ba0074cf7087a3cec46ea1"
    sha256 cellar: :any,                 arm64_sonoma:  "36a1fb1991283d9ba6d58a84f6e76d3716cc7dfa0fb485a5b607257f188627c8"
    sha256 cellar: :any,                 arm64_ventura: "b51382cb0ee46e9866f85ad4d0a28288c350fa13f02db224b8e9677a6e168a3f"
    sha256 cellar: :any,                 sonoma:        "91cd9385dbcbbb0f98735df69b8db47b5dba90114ad0e548ff10495f9b5d79c1"
    sha256 cellar: :any,                 ventura:       "882c2d7970d9bd50ce7106fa5a2f69bbd31378701fde1be08700b43cf51d1eef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6cfe1c19f1b59fc8d8cd2384efeabbea7ec95f5cf177e5641deb48ddf9debf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44f5679557f8f267512efa9038e2f6721b1da4d7b5e400dd1f9de93304c1dc6c"
  end

  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "protobuf"

  # We manually build rather than use Bazel as Bazel will build its own copy of Abseil
  # and Protobuf that get statically linked into binary. Check for any upstream changes at
  # https://github.com/protocolbuffers/protobuf-javascript/blob/main/generator/BUILD.bazel
  def install
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
