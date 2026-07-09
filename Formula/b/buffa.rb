class Buffa < Formula
  desc "Pure-Rust Protocol Buffers implementation with editions support"
  homepage "https://github.com/anthropics/buffa"
  url "https://github.com/anthropics/buffa/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "923f9c96a8bd8bbb62f53ca7893ac2a86403e5f40bc0593a36e2ffcc62706b82"
  license "Apache-2.0"
  head "https://github.com/anthropics/buffa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5215bd8d7f62a427de968825e5eb7a7727445eb67a97b706ac8ce1f583d977b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb975468773c9e781dda45291a8613cff328043c75eb055c4b625c97dfb9055e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35459460a03f8003915caf6770af3a01926f790b7afd343bc3022c4a31bee8c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f5e206fae188a5960eb5d20e9c8d95678c5076aba736b997b52a7b711583a1f"
    sha256 cellar: :any,                 arm64_linux:   "1cf98f474d2af42ab74e24785351eb30036773d97b37e3f06fbba9ec1ff61c77"
    sha256 cellar: :any,                 x86_64_linux:  "bdbed5deb3bf85a597b13e4d3bfac4ed6d41a55837c3179b051698884830c86f"
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
