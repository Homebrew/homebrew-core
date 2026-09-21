class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https://github.com/protocolbuffers/protobuf-javascript"
  url "https://github.com/protocolbuffers/protobuf-javascript/archive/refs/tags/v4.0.3.tar.gz"
  sha256 "43ea40481e7b5efdeccf4a0926226b0bd4f61386cdb819a55ce55f5828e32025"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/protocolbuffers/protobuf-javascript.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d29eb46440e0f82228cfda805b96aaf6c68b3909609208c68551b37dd113c350"
    sha256 cellar: :any, arm64_tahoe:       "3aaabe229adba9040578852d0a37bbf74a2176d4cb85df8bdd3b827c45217587"
    sha256 cellar: :any, arm64_sequoia:     "07524eb5725a28a9c2df8e6b3a967173398c18b401e938da0c354bfefba2d9a2"
    sha256 cellar: :any, arm64_linux:       "ba9a465cf03eecff43df1c3b802fd54a904ac33c57bdf7e0aa984c95e883d65c"
    sha256 cellar: :any, x86_64_linux:      "1439bc9d371cf256b74b99b4ce7801a033d7d6878e43746b8754e0c168dfd151"
  end

  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "protobuf"

  # We manually build rather than use Bazel as Bazel will build its own copy of Abseil
  # and Protobuf that get statically linked into binary. Check for any upstream changes at
  # https://github.com/protocolbuffers/protobuf-javascript/blob/main/generator/BUILD.bazel
  def install
    system ENV.cxx, "-std=c++17", "generator/generate-version-header.cc", "-o", "generate-version-header"
    system "./generate-version-header", "package.json", "generator/version.h"
    protobuf_flags = Utils.safe_popen_read("pkgconf", "--cflags", "--libs", "protobuf").chomp.split.uniq
    system ENV.cxx, "-std=c++17", "generator/js_generator.cc", "generator/protoc-gen-js.cc",
                    "generator/well_known_types_embed.cc", "-o", "protoc-gen-js", "-I.", *protobuf_flags, "-lprotoc"
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
    system formula_opt_bin("protobuf")/"protoc", "--js_out=import_style=commonjs:.", "person.proto"
    assert_path_exists testpath/"person_pb.js"
    refute_predicate (testpath/"person_pb.js").size, :zero?
  end
end
