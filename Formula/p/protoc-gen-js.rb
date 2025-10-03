class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https://github.com/protocolbuffers/protobuf-javascript"
  url "https://github.com/protocolbuffers/protobuf-javascript/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "7d3cd714bf99660ecc96882468a5a23465efca07064ff8105da634372649ee6e"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-javascript.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "549663501180ed14b58a4ba42786f7dbcb0a8afd43e1196cd80dca38d955dfdf"
    sha256 cellar: :any,                 arm64_sequoia: "4f1706dd3fa26e2abdc29d72a7327f730aee6324eb12f69d787aac10988ab954"
    sha256 cellar: :any,                 arm64_sonoma:  "3893f5fe97808fe1b89035f50230a0d157a8d3ceeb7a5ab57029f4949315d791"
    sha256 cellar: :any,                 arm64_ventura: "22f7d5fcbfc9fd011ca0059016497a6f86af6de205162e5e880a3f91751e05f7"
    sha256 cellar: :any,                 sonoma:        "bfb23af337fe2d1caa4a89fecab7b1b1475c4117721add0e7fb3975896ad7e13"
    sha256 cellar: :any,                 ventura:       "8bd3ad1569477f9cc0f998add4035bbd81215bacf46f7e579b41355abbd820c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb1a45f894813e6d02dce4bc3ca6d8b1da12ab8c25604812924c92122db2162c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc107e124e47d727df28d35d2b5899dacf383e2985024aef639a156cd11a939a"
  end

  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "protobuf@29"

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
    system Formula["protobuf@29"].bin/"protoc", "--js_out=import_style=commonjs:.", "person.proto"
    assert_path_exists testpath/"person_pb.js"
    refute_predicate (testpath/"person_pb.js").size, :zero?
  end
end
