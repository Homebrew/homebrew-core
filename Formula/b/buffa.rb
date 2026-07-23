class Buffa < Formula
  desc "Pure-Rust Protocol Buffers implementation with editions support"
  homepage "https://github.com/anthropics/buffa"
  url "https://github.com/anthropics/buffa/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "185771400b27c64ea7b93a7af204c771ce418cb720e540e79e8c5a21ede96f99"
  license "Apache-2.0"
  head "https://github.com/anthropics/buffa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a362a60523a4044a4f95e7c112d0171408e3532529f472c032ad12a34755113"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ee165b917dd4dc6d74296fe80198582f6b57422ad208f1ee0478ce46672d2ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06a8fe37025c22d225de590c6bdb4eb48209f332210757bc57dbfaed3716bd36"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ef103265f9fbe8a78af32e5f88f3c5a69e11a6c4bb4812618a7f76e3b1037c3"
    sha256 cellar: :any,                 arm64_linux:   "e69f72e5c3fb97f15ecafb9562f7fe69bd10a230db80d274713b299ae1adc69a"
    sha256 cellar: :any,                 x86_64_linux:  "90a8d463985133798fa3bebdee44b4345aff4c0d990a6db38cfab1f43c569c28"
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
