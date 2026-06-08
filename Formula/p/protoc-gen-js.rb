class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https://github.com/protocolbuffers/protobuf-javascript"
  url "https://github.com/protocolbuffers/protobuf-javascript/archive/refs/tags/v4.0.2.tar.gz"
  sha256 "a08244115ed0535971ec894abf078da90ad2c0938700612f90dc550f218627ee"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/protocolbuffers/protobuf-javascript.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d3255db6e8a744c9c1e4f2bb734ea2802de71840b0d0a92a9c7cba913b2e7308"
    sha256 cellar: :any,                 arm64_sequoia: "3e3e9b7d4a34169fd498754d1f4d63a7e8898206f6b6c2cb5eadb35f0831750e"
    sha256 cellar: :any,                 arm64_sonoma:  "a1a2d68c5e393aa1bcc18953ee80bb73246e99e3f934e484bf31581ca4c7929c"
    sha256 cellar: :any,                 sonoma:        "b8641ef8f5abbc346bb0f5afa6ca8ae9c5677b4b27165f3a32fd8e1c67c1128f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b898fc22bad13de5b800629a5846135da076a5f7b8b0267c6b5cced6b279a587"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54fe2acb88acd491bf2c3cc38b7741d9bd1817302ac6c7f9123efb1cc58d7e47"
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
    system Formula["protobuf"].bin/"protoc", "--js_out=import_style=commonjs:.", "person.proto"
    assert_path_exists testpath/"person_pb.js"
    refute_predicate (testpath/"person_pb.js").size, :zero?
  end
end
