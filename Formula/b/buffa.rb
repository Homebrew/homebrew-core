class Buffa < Formula
  desc "Pure-Rust Protocol Buffers implementation with editions support"
  homepage "https://github.com/anthropics/buffa"
  url "https://github.com/anthropics/buffa/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "16ccf3bfb5410e7a27a54e8a98688e0f5981aebef02b5f280cd588555a2d907a"
  license "Apache-2.0"
  head "https://github.com/anthropics/buffa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b93f70146e4ca95737bbabe62fcd858e068716c8387d30ff1e432cdd5c74b863"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58618226d1838ea24a109f1aa11a2070a917b6b68d5bceb34ffbb37a82d81971"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f02081861b74ae4c8794c36deb286824ca683f2391c93a3d12603004a8cbfae"
    sha256 cellar: :any_skip_relocation, sonoma:        "84aed40c28f37b2f9d3a223b900bd03827eb87fcda597c19a839ba606e3ac796"
    sha256 cellar: :any,                 arm64_linux:   "f7b6b94ed66d8d82cb00c99824e4f045c726d7390c03bfdc921ff9339e7c3c43"
    sha256 cellar: :any,                 x86_64_linux:  "5c4d11dd8a55e214e192aa6baf5ce643337be5e6ad52e863c489981a4f7ed360"
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
