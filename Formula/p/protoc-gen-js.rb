class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https://github.com/protocolbuffers/protobuf-javascript"
  url "https://github.com/protocolbuffers/protobuf-javascript/archive/refs/tags/v3.21.4.tar.gz"
  sha256 "8cef92b4c803429af0c11c4090a76b6a931f82d21e0830760a17f9c6cb358150"
  license "BSD-3-Clause"
  revision 10
  head "https://github.com/protocolbuffers/protobuf-javascript.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e1d3eb4bac2263ba923f679559e88d7b4c12f678e17399438356941b18604643"
    sha256 cellar: :any,                 arm64_sonoma:  "61cd3b85437197c9c3032340d1eb85ba1f94843487e60ce1b6338f61204c7f30"
    sha256 cellar: :any,                 arm64_ventura: "04cd632b292fabc0152c3943e52cd82ed5e8e069d5ad4098177f9498d7e34988"
    sha256 cellar: :any,                 sonoma:        "4e1ad32e594ae4a51b04667c0a136ef07a9db1e568fe9d6a303ae8308efcee55"
    sha256 cellar: :any,                 ventura:       "101b027ec794658d1a0684c7da07966c1a62463216e02c6a13b959009da82e92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b33b76262e0a6ea80580c7b069b844f3e6de051d1dd0ca0abea845dd95d859c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c81f134c3f3caa2d1e6a79ff11568332a896a1d102b5ff686b8f9f90601eb657"
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
