class Buffa < Formula
  desc "Pure-Rust Protocol Buffers implementation with editions support"
  homepage "https://github.com/anthropics/buffa"
  url "https://github.com/anthropics/buffa/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "eca43e42cfbd353c70e70134f5f5d801ab32f21e8afdebae94df1a93422e316b"
  license "Apache-2.0"
  head "https://github.com/anthropics/buffa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "137d6cb8863132538eed410a7605a927e51bfd368fc4f1a8d3b37e59db8fc849"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b02b7a1179b367e178b27620423e39f6330de108da38a43587c3b3d6150dfeb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8368acb5620852fea29eafb42d9c22bdb5889374094d5aa76c4d99fde607a511"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1a45e6141e136ea4e73c44f73763aa599daf6c110619a56fb2e22b62cd2f330"
    sha256 cellar: :any,                 arm64_linux:   "644ab3b75f4043f3af92e31e191a8986b58bcf3629f92408daeb8bf7f729f44d"
    sha256 cellar: :any,                 x86_64_linux:  "dece851aba6addc01d48cc20f2b1795d5aad5538e6c653c53ec64550c748cace"
  end

  depends_on "rust" => :build
  depends_on "protobuf"

  def install
    system "cargo", "install", *std_cargo_args(path: "protoc-gen-buffa")
    system "cargo", "install", *std_cargo_args(path: "protoc-gen-buffa-packaging")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/protoc-gen-buffa --version")

    (testpath/"sample.proto").write <<~PROTO
      syntax = "proto3";
      package example.v1;

      message Greeting {
        string message = 1;
      }
    PROTO

    (testpath/"gen").mkpath
    system "protoc",
           "--plugin=protoc-gen-buffa=#{bin}/protoc-gen-buffa",
           "--plugin=protoc-gen-buffa-packaging=#{bin}/protoc-gen-buffa-packaging",
           "--buffa_out=gen",
           "--buffa-packaging_out=gen",
           "sample.proto"

    assert_match "pub struct Greeting", (testpath/"gen/sample.rs").read
    assert_match "pub mod example", (testpath/"gen/mod.rs").read
  end
end
