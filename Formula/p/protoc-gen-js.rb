class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https://github.com/protocolbuffers/protobuf-javascript"
  url "https://github.com/protocolbuffers/protobuf-javascript/archive/refs/tags/v3.21.4.tar.gz"
  sha256 "8cef92b4c803429af0c11c4090a76b6a931f82d21e0830760a17f9c6cb358150"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/protocolbuffers/protobuf-javascript.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bd89f9b6d231eb57ffcd49b09d182fd4fb5e7186d2451de5e41b2a2013b418c2"
    sha256 cellar: :any,                 arm64_sonoma:  "4e882799851d03b2ac7d8d82e9b81b37896b536621c20dec95a0fba7801716b6"
    sha256 cellar: :any,                 arm64_ventura: "5b1c764d7c3d37d8a7fc79b788719edc7406470bcc7340aa14a5ff96055b749a"
    sha256 cellar: :any,                 sonoma:        "fe87760388900aa3f262d58f694552b112500e762b20c0b7ad337f36a7228987"
    sha256 cellar: :any,                 ventura:       "a08e4c47128afd5e4980dedae4b6d01f5fc00bb975b0bb8099dc0664fec7b8e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ad8b956a8cfba26fcaf489dd823b607a2a14dc41496be76244425b09143f334"
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
    (testpath/"person.proto").write <<~EOS
      syntax = "proto3";

      message Person {
        int64 id = 1;
        string name = 2;
      }
    EOS
    system Formula["protobuf"].bin/"protoc", "--js_out=import_style=commonjs:.", "person.proto"
    assert_path_exists testpath/"person_pb.js"
    refute_predicate (testpath/"person_pb.js").size, :zero?
  end
end
