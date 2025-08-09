class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https://github.com/protocolbuffers/protobuf-javascript"
  url "https://github.com/protocolbuffers/protobuf-javascript/archive/refs/tags/v3.21.4.tar.gz"
  sha256 "8cef92b4c803429af0c11c4090a76b6a931f82d21e0830760a17f9c6cb358150"
  license "BSD-3-Clause"
  revision 11
  head "https://github.com/protocolbuffers/protobuf-javascript.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4c9c06af42b6e81c93c88b58bcc647df32b9f9d4740433847a6c33fc7628225e"
    sha256 cellar: :any,                 arm64_sonoma:  "6fea121f040d43177b130dae1b5c48eba95889127a52cc2395aa23bc007b21f5"
    sha256 cellar: :any,                 arm64_ventura: "7cb9bbb25d1b7c1f82b9508a6627dada407cac36dd9896242da953183efda366"
    sha256 cellar: :any,                 sonoma:        "b79e4b1499f0325cbdc38e64692c597b8022e08aae43ea50341b561127dd2d5a"
    sha256 cellar: :any,                 ventura:       "6cae07a426c3754652806efec8bffde45cc048e40f42faed179c330cc7723f62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64be2f2b83996748afc0cf39f3cc0e1b8511355d19914511029fbc5d956773ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72d468a6b652ad26d9b1d96abc6fbc5ec6b16abf42b216c2aae338552e0b1b4a"
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
