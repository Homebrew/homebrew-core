class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https://github.com/protocolbuffers/protobuf-javascript"
  url "https://github.com/protocolbuffers/protobuf-javascript/archive/refs/tags/v3.21.4.tar.gz"
  sha256 "8cef92b4c803429af0c11c4090a76b6a931f82d21e0830760a17f9c6cb358150"
  license "BSD-3-Clause"
  revision 6
  head "https://github.com/protocolbuffers/protobuf-javascript.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0b2b125602351e2ed61b909ef6669806e9acb81c2296013269ff30683ce6fd4c"
    sha256 cellar: :any,                 arm64_sonoma:  "ca2915808a19b35f82a2132a63a1a4120ed664c2b78bc9a473e53d7a9352cbe8"
    sha256 cellar: :any,                 arm64_ventura: "94938024670889425e681c0b7ef2938a3db81cc09d396160c0509c7321e860be"
    sha256 cellar: :any,                 sonoma:        "4cd0033b53dd404caa04edbface7f7e70b488eaf25e7eb12eda3cb120ea93543"
    sha256 cellar: :any,                 ventura:       "d7fbc7a2e8b626aa70f27ecbc0f06d9820f36870e37e15863eb47bbcd022302c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8330a356f555b2cb747cb5f6ffd6eb142f4c937e171e24480bac698c08244d54"
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
