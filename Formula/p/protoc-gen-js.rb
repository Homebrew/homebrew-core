class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https://github.com/protocolbuffers/protobuf-javascript"
  url "https://github.com/protocolbuffers/protobuf-javascript/archive/refs/tags/v4.0.2.tar.gz"
  sha256 "a08244115ed0535971ec894abf078da90ad2c0938700612f90dc550f218627ee"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/protocolbuffers/protobuf-javascript.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b8c1a0ade17d45161443083e123d14792368a469c253cf86e450f4e2fa6943bb"
    sha256 cellar: :any,                 arm64_sequoia: "1ea99751e689243b6458729a0ccdb09ef2ed3bdaebd5d3c0469bec6818d59e19"
    sha256 cellar: :any,                 arm64_sonoma:  "ad398ab6aec7e19b2aa0be33c92c4957b7a5176aa7ca0a763cbb8a634cd46ef4"
    sha256 cellar: :any,                 sonoma:        "82f428a2770afa7da93a85173a397182c57658d5b81287dfcf0616852e653dfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcbd06fdd4ccda8bcb915bc3e77575453923bc734d3009fd5ca6b0e775137f6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e7c5044ac80c0be7dce48b6653ea2a9b73c4b6679f9b903248278890021a9a0"
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
