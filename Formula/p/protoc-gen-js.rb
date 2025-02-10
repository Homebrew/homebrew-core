class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https://github.com/protocolbuffers/protobuf-javascript"
  url "https://github.com/protocolbuffers/protobuf-javascript/archive/refs/tags/v3.21.4.tar.gz"
  sha256 "8cef92b4c803429af0c11c4090a76b6a931f82d21e0830760a17f9c6cb358150"
  license "BSD-3-Clause"
  revision 8
  head "https://github.com/protocolbuffers/protobuf-javascript.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "10a6dc802499f1666dd19e86c0edada7bbda19d07580da53e1a006539338c18b"
    sha256 cellar: :any,                 arm64_sonoma:  "c36d467208286205d4d2d146f8855b4664d5e2f94e2a986563e52a8022cffccb"
    sha256 cellar: :any,                 arm64_ventura: "4de2c36868a911ea09814303d961351b73baa9c7cdb822e5e66b184ead56b9de"
    sha256 cellar: :any,                 sonoma:        "4432f9ef2b0d3a8d6097c4a5eb5feee2578863db91b10466a21ddc5f20ba9713"
    sha256 cellar: :any,                 ventura:       "c8a8278f6a1de7e6405d79d45fee1b10b0c0f88d38957522749ef9f69e279e70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0f6aeb71ad79dd68b09b710f35be757f370939fc436ce7e2e232794f2f0e7c7"
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
