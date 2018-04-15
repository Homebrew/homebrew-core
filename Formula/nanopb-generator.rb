class NanopbGenerator < Formula
  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.3.9.1.tar.gz"
  sha256 "e677290fdb419a3d437b824ef9eac02b8d1672fb30d60dd1f3113eae405b1f5b"

  bottle do
    cellar :any_skip_relocation
    sha256 "162e82a5d987e11b4b451d6d23a5d1e4e193ba2a802ab8eeed2395910519598c" => :high_sierra
    sha256 "162e82a5d987e11b4b451d6d23a5d1e4e193ba2a802ab8eeed2395910519598c" => :sierra
    sha256 "162e82a5d987e11b4b451d6d23a5d1e4e193ba2a802ab8eeed2395910519598c" => :el_capitan
  end

  depends_on "python@2"
  depends_on "protobuf"

  conflicts_with "mesos",
    :because => "they depend on an incompatible version of protobuf"

  def install
    cd "generator" do
      system "make", "-C", "proto"
      inreplace "nanopb_generator.py", %r{^#!/usr/bin/env python$},
                                       "#!/usr/bin/python"
      libexec.install "nanopb_generator.py", "protoc-gen-nanopb", "proto"
      bin.install_symlink libexec/"protoc-gen-nanopb", libexec/"nanopb_generator.py"
    end
  end

  test do
    (testpath/"test.proto").write <<~EOS
      syntax = "proto2";

      message Test {
        required string test_field = 1;
      }
    EOS
    system Formula["protobuf"].bin/"protoc",
      "--proto_path=#{testpath}", "--plugin=#{bin}/protoc-gen-nanopb",
      "--nanopb_out=#{testpath}", testpath/"test.proto"
    system "grep", "test_field", testpath/"test.pb.c"
    system "grep", "test_field", testpath/"test.pb.h"
  end
end
